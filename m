From: Tao Ma <tao.ma@oracle.com>
Date: Wed, 02 Sep 2009 10:21:44 +0800
Subject: [Ocfs2-devel] [PATCH 12/14] ocfs2: Let ocfs2_xa_prepare_entry()
	do space checks.
In-Reply-To: <20090902021121.GB9165@mail.oracle.com>
References: <1251448563-12508-1-git-send-email-joel.becker@oracle.com>
	<1251448563-12508-13-git-send-email-joel.becker@oracle.com>
	<4A9DD057.3050306@oracle.com>
	<20090902021121.GB9165@mail.oracle.com>
Message-ID: <4A9DD6B8.2050205@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



Joel Becker wrote:
> On Wed, Sep 02, 2009 at 09:54:31AM +0800, Tao Ma wrote:
>> I just have one concern. Here we used to check whether count ==
>> ocfs2_xattr_max_xe_in_bucket(inode->i_sb) which make sure
>> ocfs2_xattr_entry to be stored only in the first block of a
>> bucket(this is a legacy issue before you added ocfs2_xattr_bucket
>> abstraction), so now you remove this restriction. Maybe it is ok
>> since now we already read the whole bucket and it looks that your
>> current xa_* abstraction can handle it. Just want to remind you of
>> it.
> 
> 	Oh, right.  I knew about that, but clearly forgot while I was
> doing this particular patch.  Intellectually I'd like to remove the
> restriction, as that makes our code more general and flexible.  But all
> code prior to this, even if it read the whole bucket, assumed that the
> entries were in a linear buffer.  Before this xa_loc abstraction, that's
> false.  We'd have older kernels (2.6.30, 2.6.31) crashing on anything
> with this problem.  Of course, how many people have that many xattrs?
> Maybe we can just figure that by they time they have that many, they
> have 2.6.32? :-)
yeah, I'd like to remove it also after I got from you that reading a 4K 
bucket is as fast as or even faster than we read the 1st and 3rd block 
individually. So let us do it.

btw, please remove ocfs2_xattr_max_xe_in_bucket since now there are no 
caller for it.

Regards,
Tao
