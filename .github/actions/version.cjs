const fs = require('fs');

const version = process.env.RELEASE_VERSION;
const newVersion = version.replace('v', '');

try {
    let manifestFile = fs.readFileSync('fxmanifest.lua', 'utf8');
    const newFileContent = manifestFile.replace(/\bversion\s+(.*)$/gm, `version      '${newVersion}'`);
    fs.writeFileSync('fxmanifest.lua', newFileContent);
} catch (err) {
    console.error(err);
}
