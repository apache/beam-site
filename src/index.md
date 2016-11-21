---
layout: default
---

TODO - Add info from v2 main page! 

<hr>
<div class="row">
  <div class="col-md-6">
    <h3>Blog</h3>
    <div class="list-group">
    {% for post in site.posts %}
    <a class="list-group-item" href="{{ post.url | prepend: site.baseurl }}">{{ post.date | date: "%b %-d, %Y" }} - {{ post.title }}</a>
    {% endfor %}
    </div>
  </div>
  <div class="col-md-6">
    <h3>Twitter</h3>
    <a class="twitter-timeline" href="https://twitter.com/ApacheBeam" data-widget-id="697809684422533120">Tweets by @ApacheBeam</a>
    <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+"://platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script>
  </div>
</div>

<hr>

<p style="text-align:center"><img align="center" src="https://incubator.apache.org/images/apache-incubator-logo.png" alt="Apache Incubator Logo"></p>

Apache Beam is an effort undergoing incubation at [The Apache Software Foundation (ASF)](http://www.apache.org) sponsored by the Apache Incubator PMC. Incubation is required of all newly accepted projects until a further review indicates that the infrastructure, communications, and decision making process have stabilized in a manner consistent with other successful ASF projects. While incubation status is not necessarily a reflection of the completeness or stability of the code, it does indicate that the project has yet to be fully endorsed by the ASF.


Apache Beam (incubating) is available under [Apache License, version 2.0](http://www.apache.org/licenses/LICENSE-2.0).
