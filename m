From: tristan.ye <tristan.ye@oracle.com>
Date: Thu, 03 Sep 2009 18:48:41 +0800
Subject: [Ocfs2-devel] [PATCH 10/14] ocfs2: Allocation
	in	ocfs2_xa_prepare_entry() values in ocfs2_xa_store_value()
In-Reply-To: <20090902083711.GB10257@mail.oracle.com>
References: <1251448563-12508-1-git-send-email-joel.becker@oracle.com>
	<1251448563-12508-11-git-send-email-joel.becker@oracle.com>
	<4A9CE168.6050107@oracle.com> <20090901202111.GH3826@mail.oracle.com>
	<20090902015158.GA9165@mail.oracle.com> <4A9DFBBF.1010102@oracle.com>
	<20090902083711.GB10257@mail.oracle.com>
Message-ID: <1251974921.6862.44.camel@tristan-laptop.cn.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, 2009-09-02 at 01:37 -0700, Joel Becker wrote:
> On Wed, Sep 02, 2009 at 12:59:43PM +0800, Tao Ma wrote:
> > OK, I think I have finished reviewing the whole patch set. Thanks
> > for the work. You can add my ACK to this set now. And once it get
> > merged into merge-window, I can ask tristan to run it with his xattr
> > test case.
> 
> 	All of the changes are in xa_loc.  Can you have tristan against
> that first?  I don't want to push this into merge_window without at
> least a quick pass to make sure there isn't a disasterous idea in there
> :-)

Joel,

Your patches set against xattr on xa_loc branch made the life of
xattr-testing be suffering:-(

The tests failed at the very beginning with a lite workload... I also
tried to do some tests manually aiming to narrow down the problem,
following bugs can provide you detailed info when I hit error/panic. I'm
not sure whether they were in same kind or not, just filed them
separately with different symptoms.

http://oss.oracle.com/bugzilla/show_bug.cgi?id=1168

http://oss.oracle.com/bugzilla/show_bug.cgi?id=1169

http://oss.oracle.com/bugzilla/show_bug.cgi?id=1170

http://oss.oracle.com/bugzilla/show_bug.cgi?id=1171


Regards,
Tristan.





> 
> Joel
> 
