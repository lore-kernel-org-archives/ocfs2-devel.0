From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 24 Oct 2008 14:15:35 +0800
Subject: [Ocfs2-devel] [PATCH 3/3] ocfs2/xattr: Proper hash collision
 handle in bucket division.v2
In-Reply-To: <20081024060238.GB31082@ca-server1.us.oracle.com>
References: <1224218678-32196-3-git-send-email-tao.ma@oracle.com>
	<1224204876-26802-1-git-send-email-tao.ma@oracle.com>
	<20081023232030.GE12751@mail.oracle.com>
	<49011C51.1030806@oracle.com>
	<20081024011451.GH12751@mail.oracle.com>
	<490124A0.1020407@oracle.com>
	<20081024060238.GB31082@ca-server1.us.oracle.com>
Message-ID: <49016807.9000901@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



Joel Becker wrote:
> On Fri, Oct 24, 2008 at 09:28:00AM +0800, Tao Ma wrote:
>> Joel Becker wrote:
>>> 	Are you saying that you usually have only one xattr per bucket,
>>> even with many xattrs?  Because if we have n xattrs per bucket, your
>>> function will walk down from middle to 0 (half the bucket) unless n is
>>> 1.
>> No. See ocfs2_xattr_find_divide_pos.
> 
> 	I realized on the drive home that, if the common case is no
> duplicate hash values, the first loop triggers on its first step.  I
> think that's what you are saying.
> 	But boy, it's not obvious that's what it is doing.  And then you
> have that weird (middle == count - 1) check that makes no sense.  And
> then you go the other way.  I'd love to find a set of comments and code
> that makes it more understandable.
> 
>>> 	Your function would be much more understandable even if it just
>>> used my xe_cmp() function.  Then some comment about what you are trying
>>> to achieve (I guessed at that), and perhaps a mention of the common
>>> case.
>> OK, I will add some comments for it. As for xe_cmp, can I use "cmp_xe" 
>> which already exists in xattr.c?
> 
> 	I have an idea to do what you're doing, but cleaner.  I'll look
> at cmp_xe and try again in the morning.
cool, so waiting for your perfect code. ;)

Regards,
Tao
