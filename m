From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 23 Oct 2008 22:59:57 -0700
Subject: [Ocfs2-devel] [PATCH 2/3] ocfs2/xattr: Merge xattr
	set	transaction.
In-Reply-To: <49012234.7050807@oracle.com>
References: <48F81730.9020809@oracle.com>
	<1224218678-32196-2-git-send-email-tao.ma@oracle.com>
	<20081023214036.GC12751@mail.oracle.com>
	<49011A69.9040003@oracle.com>
	<20081024010912.GG12751@mail.oracle.com>
	<49012234.7050807@oracle.com>
Message-ID: <20081024055957.GA31082@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Oct 24, 2008 at 09:17:40AM +0800, Tao Ma wrote:
> Joel Becker wrote:
>> On Fri, Oct 24, 2008 at 08:44:25AM +0800, Tao Ma wrote:
>>> Joel Becker wrote:
>> 	No, I found it incredibly hard to wade through, because I'd get
>> to a point where I'd lost track of where I was, and I would look and see
>> I'd only viewed 44% of the patch :-)
>> 	There's a lot going on in here.  You're moving the transaction
>> calculations around, moving locks, reorganizing the calls to the various
>> set handlers, and that's just for starters.
> OK, I will try to separate it into small ones.

	Thanks.  Don't worry about making them tiny - there's a lot
there.  But see if you can think of a couple logical steps.

>> 	For example, when setting an xattr you try ibody_set() first.
>> If that succeeds, you then go ahead and clear the same xattr out of the
>> external block/tree.  So if there is an extend_trans() somewhere in
>> there, and it commits a change, you could crash and have the xattr in
>> both the ibody and the external block/tree.  The same with the reverse
>> (set in external, commit, clear in ibody, crash).  We need to make sure
>> we either don't actually have these cases happen or handle them
>> gracefully.
> yeah, you may be right. As my previous e-mail said, I will try to calculate 
> all the credits in the beginning. Let's see how it works.

	Cool.  If you can, awesome.  If not, let's make sure that the
remounted filesystem can handle whatever's there.

Joel

-- 

"Nearly all men can stand adversity, but if you really want to
 test a man's character, give him power."
	- Abraham Lincoln

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
