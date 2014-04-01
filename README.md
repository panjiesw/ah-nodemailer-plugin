actionhero-nodemailer-plugin
============================

**\*WORK IN PROGRESS\***

 - [What][1]
     - [Feature List][2]
 - How
     - [Installing][3]
     - [Configuration][4]
     - [Usage][5]
     - [TODO][6]

<a name="what"></a>
What
----
Mail sending plugin for [actionhero][7] API Server using [nodemailer][8]. Provides ***api methods*** and ***task runner*** to configure and send Mail from within an actionhero API Server. It's also integrated with mail template capability from [email-templates][9] package.

<a name="features"></a>
### Feature List

 - Various supported mail transport by [nodemailer][10].
 - Mail template capability from email-templates package, using [ejs][11] / [jade][12] / [swig][13] / [handlebars][14].
 - Built in task for sending mail.
 - Easy configuration.
 - Supports [Promises/A+][15] and classic callback style

<a name="how"></a>
How
---
<a name="installing"></a>
### Installing
In your actionhero project, install the plugin from NPM. ***NOT YET PUBLISHED***

    npm install ah-nodemailer-plugin --save

<a name="configuration"></a>
### Configuration
After installation is finished, there will be a configuration file copied to your ``/config`` folder named ``mailer.js``. Below is the default configuration file content, modify it to meet your needs.

```javascript
exports["default"] = {
  mailer: function(api) {
    return {

      /*
      Type of transport to use.
      See [nodemailer](http://www.nodemailer.com/docs/transports).
      If set to ``stdout``, no email will be sent,
      instead it will be piped to stdout.
       */
      transport: "stdout",

      /*
      This is an example of options to use in transport creation, using SMTP.
      For other nodemailer supported transport, please see nodemailer's site.
       */
      options: {

        /*
        an optional well known service identifier ("Gmail", "Hotmail" etc.,
        see Well known Services for a list of supported services)
        to auto-configure host, port and secure connection settings
         */
        service: "Gmail",
        host: "smtp.example.com",
        port: 25,
        secureConnection: false,
        name: "example-mailer",
        auth: {
          user: "email.user@example.com",
          pass: "some_password"
        }
      },

      /*
      Default options when sending email.
      Define other fields here if you wish.
       */
      mailOptions: {
        from: "admin@somewhere.com"
      },

      /*
      Email templates directory.
      Defaults to root `templates` directory.
       */
      templates: "" + __dirname + "/../templates"
    };
  }
};
```

You can see a list of supported transports in [nodemailer site][16]

<a name="usage"></a>
### Usage
The api is exposed in ``api.Mailer`` object. To send mail, you can use the ``api.Mailer.send(options, callback)`` method directly or better yet use the built in task named ``sendMail`` so the request is not held by mail sending process.

```javascript
// Using api.Mailer.send directly
options = {
  mail: {
    to: 'someone@somewhere.com',
    subject: 'Hello Nodemailer From Actionhero!'
  },
  locals: {
    foo: 'bar',
    baz: 'derp'
  },
  template: 'welcome'
};

api.Mailer.send(options)
.then(function(response) {
  api.log('Mail sent successfully!');
  // do something else
}).catch(function(error) {
  api.log('Something bad happened', 'crit', error.message);
});

// or using classic callback
api.Mailer.send(options, function(error, response) {
  if(error)
    api.log('Something bad happened', 'crit', error.message);
  else {
    api.log('Mail sent successfully!');
    // do something else
  }
});

// Using the built in task runner
api.tasks.enqueue('sendMail', options, 'default', function(error, done) {
  //done
})
```

<a name="todo"></a>
TODO
----

 - Provide Mail Template documentation and notes.
 - Provide API Reference in README.
 - Provide test.
 - Provide implementation sample.
 - Provide postinstall scripts.


  [1]: #what
  [2]: #features
  [3]: #installing
  [4]: configuration
  [5]: #usage
  [6]: #todo
  [7]: http://actionherojs.com
  [8]: http://www.nodemailer.com
  [9]: https://github.com/niftylettuce/node-email-templates
  [10]: http://www.nodemailer.com
  [11]: https://github.com/visionmedia/ejs
  [12]: https://github.com/visionmedia/jade
  [13]: https://github.com/paularmstrong/swig
  [14]: https://github.com/wycats/handlebars.js
  [15]: http://promises-aplus.github.io/promises-spec/
  [16]: http://www.nodemailer.com/docs/transports
