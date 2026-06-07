const fs = require('fs');
const path = require('path');

async function uploadToSlack() {
  const token = process.env.SLACK_BOT_TOKEN;
  const channelId = process.env.SLACK_CHANNEL_ID;
  const filePath = process.argv[2];
  const initialComment = process.argv[3] || '';

  if (!token || !channelId || !filePath) {
    console.error('Missing required arguments or env vars (SLACK_BOT_TOKEN, SLACK_CHANNEL_ID, filePath)');
    process.exit(1);
  }

  const absolutePath = path.resolve(filePath);
  if (!fs.existsSync(absolutePath)) {
    console.error(`File not found: ${absolutePath}`);
    process.exit(1);
  }

  const filename = path.basename(absolutePath);
  const fileStats = fs.statSync(absolutePath);
  const length = fileStats.size;

  console.log(`Getting upload URL for ${filename} (${length} bytes)...`);

  // Step 1: files.getUploadURLExternal
  const getUrlResponse = await fetch('https://slack.com/api/files.getUploadURLExternal', {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${token}`,
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: new URLSearchParams({
      filename,
      length: String(length),
    }),
  });

  const getUrlData = await getUrlResponse.json();
  if (!getUrlData.ok) {
    console.error('Failed to get upload URL:', getUrlData.error);
    process.exit(1);
  }

  const { upload_url, file_id } = getUrlData;
  console.log(`Uploading file content to Slack CDN...`);

  // Step 2: Upload file content
  const fileBuffer = fs.readFileSync(absolutePath);
  const uploadResponse = await fetch(upload_url, {
    method: 'POST',
    body: fileBuffer,
  });

  if (!uploadResponse.ok) {
    console.error('Failed to upload file content:', uploadResponse.statusText);
    process.exit(1);
  }

  console.log(`Completing upload and sharing in channel ${channelId}...`);

  // Step 3: files.completeUploadExternal
  const filesArray = [{ id: file_id, title: filename }];
  const completeResponse = await fetch('https://slack.com/api/files.completeUploadExternal', {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${token}`,
      'Content-Type': 'application/json; charset=utf-8',
    },
    body: JSON.stringify({
      files: filesArray,
      channel_id: channelId,
      initial_comment: initialComment,
    }),
  });

  const completeData = await completeResponse.json();
  if (!completeData.ok) {
    console.error('Failed to complete upload:', completeData.error);
    process.exit(1);
  }

  console.log('File successfully uploaded and shared on Slack!');
}

uploadToSlack().catch(err => {
  console.error('Unexpected error:', err);
  process.exit(1);
});
