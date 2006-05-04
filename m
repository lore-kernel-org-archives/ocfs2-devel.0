From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Thu, 4 May 2006 15:30:37 -0700
Subject: [Ocfs2-devel] OCFS2 features RFC - separate journal?
In-Reply-To: <445A7EF3.2000701@google.com>
References: <20060425183553.GB10524@ca-server1.us.oracle.com>
	<445936FE.90401@google.com> <44594AE2.9080802@oracle.com>
	<44594EC9.3040407@google.com> <445A6A61.2090009@oracle.com>
	<445A7EF3.2000701@google.com>
Message-ID: <20060504223037.GB21588@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, May 04, 2006 at 03:23:47PM -0700, Daniel Phillips wrote:
> >>It is worth remembering that not every OCFS2 user will be running it on a
> >>big expensive SAN.  Probably not even the majority.
> >
> >Well, that's debatable.  My only point, though, is that there are higher
> >priority things that we should get to first because they affect *everyone*.
> 
> By all means, prioritize them.  Did separate journals make the list, even
> if well towards the end?
It's on the list now.

> 
> >If the lack of external journals makes you sad, well, I'm sorry to hear
> >that.  We certainly wouldn't turn away patches if someone got to it
> >before us.
> 
> By proposing a feature that I do not also implicitly propose that Oracle
> employees have to do the work.  This is a quick hack after all, I would be
> happy to contribute.
By all means. It should be a fairly straightfoward change. Out of
curiousity, are we talking about a single journal device (all slot journals
on one disk) or one device per journal?
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh at oracle.com
