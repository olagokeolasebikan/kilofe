const express = require('express');
const app = express();
app.get('/', (req, res) => {
  const msg = 'hello world';
  console.log(msg);
  res.send(msg);
});
app.listen(8626, () => console.log('Our server is running'));