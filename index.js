const app = require('./app.js');

app.get("/testing",(req,res,next)=>{
    try {
        return res.status(200).send("Testing route 123456!@#")
    } catch (error) {
        return res.status(500).send("Server error")
    }
})

app.listen(8000, () => {
    console.log("Running on 8081")
})