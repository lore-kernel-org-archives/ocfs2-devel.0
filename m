From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 12 Jun 2009 09:04:14 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Prevent mount with "-o acl" if acl
 isn't supported.
In-Reply-To: <20090611155814.GE11636@ca-server1.us.oracle.com>
References: <1244667835-16907-1-git-send-email-tao.ma@oracle.com>
	<20090611154349.GD11636@ca-server1.us.oracle.com>
	<20090611155814.GE11636@ca-server1.us.oracle.com>
Message-ID: <4A31A98E.3030500@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



Joel Becker wrote:
> On Thu, Jun 11, 2009 at 08:43:49AM -0700, Joel Becker wrote:
>> On Thu, Jun 11, 2009 at 05:03:55AM +0800, Tao Ma wrote:
>>> Currently, if we don't enable CONFIG_OCFS2_FS_POSIX_ACL, ocfs2
>>> will not support acl. That is OK.
>>>
>>> But in the following case:
>>> 1. kernel isn't built to support acl.
>>> 2. mount -t ocfs2 -o acl /dev/sdx /mnt/ocfs2.
>>> It sucesses. And what's more, if I do "mount|grep sdx" will get
>>> /dev/sdx on /mnt/ocfs2 type ocfs2 (rw,acl,heartbeat=none)
>>>
>>> So a normal user will just think acl now is ok for the volume and
>>> he will surely be puzzled when he tries setfacl and fails with
>>> "Operation not supported".
>>>
>>> The good thing is that the kernel already printk some useful
>>> information, so this patch just tries to prevent the user from
>>> mounting the volume.
>> 	Hmm, everyone else seems to do it the way we have been.  Trying
>> to think about the surprise you describe vs the surprise of ocfs2 being
>> different than other linux filesystms.
> 
> 	Ok, I bounced this off of various fs developers, and there was
> significant support for leaving it as-is.  Basically, it would suck for
> every filesystem in fstab to fail to mount just because you changed your
> kernel.
OK, fair enough. Thank.

Regards,
Tao
