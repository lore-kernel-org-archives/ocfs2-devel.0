From: tristan.ye <tristan.ye@oracle.com>
Date: Tue, 08 Sep 2009 09:25:14 +0800
Subject: [Ocfs2-devel] [PATCH 10/14] ocfs2: Allocation
	in	ocfs2_xa_prepare_entry() values in ocfs2_xa_store_value()
In-Reply-To: <20090905013529.GD945@mail.oracle.com>
References: <1251448563-12508-1-git-send-email-joel.becker@oracle.com>
	<1251448563-12508-11-git-send-email-joel.becker@oracle.com>
	<4A9CE168.6050107@oracle.com> <20090901202111.GH3826@mail.oracle.com>
	<20090902015158.GA9165@mail.oracle.com> <4A9DFBBF.1010102@oracle.com>
	<20090902083711.GB10257@mail.oracle.com>
	<1251974921.6862.44.camel@tristan-laptop.cn.oracle.com>
	<20090905013529.GD945@mail.oracle.com>
Message-ID: <1252373114.23803.1.camel@tristan-laptop.cn.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, 2009-09-04 at 18:35 -0700, Joel Becker wrote:
> On Thu, Sep 03, 2009 at 06:48:41PM +0800, tristan.ye wrote:
> > Your patches set against xattr on xa_loc branch made the life of
> > xattr-testing be suffering:-(
> > 
> > The tests failed at the very beginning with a lite workload... I also
> > tried to do some tests manually aiming to narrow down the problem,
> > following bugs can provide you detailed info when I hit error/panic. I'm
> > not sure whether they were in same kind or not, just filed them
> > separately with different symptoms.
> 
> 	It was all dumb mistakes by me.  Thanks for the excellent tests,
> they helped me narrow down each problem.
> 
> > http://oss.oracle.com/bugzilla/show_bug.cgi?id=1168
> > http://oss.oracle.com/bugzilla/show_bug.cgi?id=1169
> > http://oss.oracle.com/bugzilla/show_bug.cgi?id=1170
> > http://oss.oracle.com/bugzilla/show_bug.cgi?id=1171
> 
> 	These all have patches now.  The fixes are pushed to the xa_loc
> branch, so if you regrab that, they should be fixed.  Let me know what
> else I broke :-)

The above bugs got fixed applying your latest patches, but test still
gets blocked by following bug:

http://oss.oracle.com/bugzilla/show_bug.cgi?id=1172


Regards,
Tristan


> 
> Joel
> 
