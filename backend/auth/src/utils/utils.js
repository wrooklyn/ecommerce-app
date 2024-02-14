const nodemailer = require('nodemailer');

const verifyEmail = async(email, link)=>{
    try{
        let transporter = nodemailer.createTransport({
                service: "Gmail",
                auth:{
                    user: process.env.VERIFICATION_MAIL_USER,
                    pass: process.env.VERIFICATION_MAIL_PASS
                }
            }
        );
        let info = await transporter.sendMail({
            from:process.env.VERIFICATION_MAIL_USER,
            to:email,
            subject: "Food Express - Account Verification",
            text: "Welcome",
            html: `<span>Please, click <a href=${link}>here</a> to verify your email.</span>`
        })
        return {success: true, msg: "Operation successful."};
    }catch(err){
        console.log(err);
        return {success:false, msg: err}; 
    }
}

module.exports = { verifyEmail }

