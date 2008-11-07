From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 07 Nov 2008 09:05:17 +0800
Subject: [Ocfs2-devel] [PATCH 01/15] ocfs2/xattr: Only extend xattr
 bucket in need.
In-Reply-To: <20081106194531.GD15154@wotan.suse.de>
References: <49099B13.9030802@oracle.com>
	<1225345335-11527-1-git-send-email-tao.ma@oracle.com>
	<20081106194531.GD15154@wotan.suse.de>
Message-ID: <4913944D.40208@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



Mark Fasheh wrote:
> On Thu, Oct 30, 2008 at 01:42:11PM +0800, Tao Ma wrote:
>> When the first block of a bucket is filled up with xattr
>> entries, we normally extend the bucket. But if we are
>> just replace one xattr with small length, we don't need
>> to extend it. This is important since we will calculate
>> what we need before the transaction and in this situation
>> no resources will be allocated.
> 
> Ok, looks good. Am I correct in thinking that this is a fix which should go
> upstream before 2.6.28 is out?
en, this should not be called a bug fix. Maybe an improvement. In old 
implementation, we extend the bucket with a less restriction. And since 
we allocate resource in ocfs2_extend_xattr_bucket, it will not cause a 
problem. But if we want to merge the transactions into one, I calculate 
the resource needed in a more strict way, so it is a problem at that time.

anyway, you can push it before 2.6.28 as you wish.

Regards,
Tao
