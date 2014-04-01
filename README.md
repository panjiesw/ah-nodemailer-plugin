actionhero-nodemailer-plugin
============================

Index
-----

 - [What][1]
     - [Feature List][2]
 - [How][3]
     - [Installing][4]
     - [Configuration][5]
     - [Mail Templates][6]
     - [Usage][7]
 - [API Methods][8]
 - [TODO][9]

<a name="what"></a>
What
----
Mail sending plugin for [actionhero][10] API Server using [nodemailer][11]. Provides ***api methods*** and ***task runner*** to configure and send Mail from within an actionhero API Server. It's also integrated with mail template capability from [email-templates][12] package.

<a name="features"></a>
### Feature List

 - Various supported mail transport by [nodemailer][13].
 - Mail template capability from email-templates package, using [ejs][14] / [jade][15] / [swig][16] / [handlebars][17].
 - Built in task for sending mail.
 - Easy configuration.
 - Supports [Promises/A+][18] and classic callback style

<a name="how"></a>
How
---
<a name="installing"></a>
### Installing
**\*NOTE!** First, make sure you have a ``plugins`` directory inside your actionhero's ``config`` directory. It's considered a good practice to group configuration files from ah-plugin package and i will do so for any plugin i release. The postinstall script will copy the config file to the directory and will throw error if there is no ``plugins`` directory. I will fix this in the future.

After that, in your actionhero project, install the plugin from NPM.

    npm install ah-nodemailer-plugin --save

<a name="configuration"></a>
### Configuration
After installation is finished, there will be a configuration file copied to your ``/config/plugins`` folder named ``mailer.js``. Below is the default configuration file content, modify it to meet your needs.

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
      templates: "" + __dirname + "/../../templates"
    };
  }
};
```

You can see a list of supported transports in [nodemailer site][19]

<a name="templates"></a>
### Mail Templates
This plugin supports, or rather **required** for now, to use mail template. By default you have to create a folder called ``templates`` in your root actionhero project. In there, place folders of templates with template files named ``html.{{template engine}}``, ``text.{{template engine}}``, and/or, ``style.{{CSS pre-processor}}``. See [node-email-templates][20] for more detailed explanation.

```
your-actionhero-project
├── actions
├── config
├── ...
├── templates
    ├── welcome
    |   ├── html.ejs
    |   ├── text.ejs
    |   ├── style.less
    |
    ├── resetPassword
    |   ├── html.ejs
    |   ├── text.ejs
    |   ├── style.less
    |
    ├── etc.etc.
```
The location of ``templates`` directory can be configured in ``mailer.js`` configuration file above, **relative to the config file's location**.

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

<a name="api"></a>
API Methods
-----------
### api.Mailer.send(options, callback)
Send mail with nodemailer plugin. Returns a promise object which will be resolved with mail sending response object, or rejected if there is any error.

 - ``options`` (required) hash of option to send the email, consists of this following fields:
     - ``mail`` The email message field, as described [here][21]. You can provide default values in ``mailer.js`` config under ``mailOptions`` field.
     - ``locals`` The data to provide to the template file.
     - ``template`` The template name to use.
 - ``callback`` (optional) Function to call after the mail sending process is finished. Will be called with 2 arguments, ``error`` and ``response``.

### api.tasks.enqueue('sendMail', options, queueName, callback)
Send mail through a task named ``sendMail``. The ``options`` argument is the same as above.

<a name="todo"></a>
TODO
----

 - Provide test.
 - Provide implementation sample.


  [1]: #what
  [2]: #features
  [3]: #how
  [4]: #installing
  [5]: configuration
  [6]: #templates
  [7]: #usage
  [8]: #api
  [9]: #todo
  [10]: http://actionherojs.com
  [11]: http://www.nodemailer.com
  [12]: https://github.com/niftylettuce/node-email-templates
  [13]: http://www.nodemailer.com
  [14]: https://github.com/visionmedia/ejs
  [15]: https://github.com/visionmedia/jade
  [16]: https://github.com/paularmstrong/swig
  [17]: https://github.com/wycats/handlebars.js
  [18]: http://promises-aplus.github.io/promises-spec/
  [19]: http://www.nodemailer.com/docs/transports
  [20]: https://github.com/niftylettuce/node-email-templates#quick-start
  [21]: https://github.com/andris9/Nodemailer#e-mail-message-fields
