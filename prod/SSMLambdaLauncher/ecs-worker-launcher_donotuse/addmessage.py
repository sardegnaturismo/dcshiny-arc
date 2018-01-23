var QUEUE_URL = 'https://sqs.us-east-1.amazonaws.com/{AWS_ACCUOUNT_}/matsuoy-lambda';
var AWS = require('aws-sdk');
var sqs = new AWS.SQS({region : 'us-east-1'});

exports.handler = function(event, context) {
  var params = {
    MessageBody: JSON.stringify(event),
    QueueUrl: QUEUE_URL
  };
  sqs.sendMessage(params, function(err,data){
    if(err) {
      console.log('error:',"Fail Send Message" + err);
      context.done('error', "ERROR Put SQS");  // ERROR with message
    }else{
      console.log('data:',data.MessageId);
      context.done(null,'');  // SUCCESS 
    }
  });
}