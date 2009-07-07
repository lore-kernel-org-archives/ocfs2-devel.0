From: Jeff Mahoney <jeffm@suse.com>
Date: Tue, 07 Jul 2009 17:22:12 -0400
Subject: [Ocfs2-devel] [PATCH 5/5] ocfs2: Disable orphan scanning for
 local and hard-ro mounts
In-Reply-To: <4A53B967.10909@oracle.com>
References: <1245696007-29494-1-git-send-email-sunil.mushran@oracle.com>	<1245696007-29494-2-git-send-email-sunil.mushran@oracle.com>	<20090622192509.GB3902@mail.oracle.com>
	<4A3FE900.30405@oracle.com> <20090622210631.GC3902@mail.oracle.com>
	<4A53B410.3040704@suse.com> <4A53B967.10909@oracle.com>
Message-ID: <4A53BC84.5000405@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Sunil Mushran wrote:
> Jeff Mahoney wrote:
>> There's a problem with this patch that I ran into while testing
>> 2.6.31-rc2. ocfs2_orphan_scan_stop expects that ocfs2_orphan_scan_init
>> was called. If the mount fails for any reason, ocfs2_dismount_volume
>> calls ocfs2_orphan_scan_stop. The thing is that ocfs2_dismount_volume
>> will never get called in that path after ocfs2_orphan_scan_init is
>> called, so we oops when calling cancel_delayed_work on an uninitialized
>> work queue.
>>
>> The attached patch fixes it up.
>>
>> -Jeff
> 
> Jeff, Thanks. For some reason, my mounts don't fail. ;)

Yeah, mine don't usually either, but I installed our desktop product on
one of my development nodes and gnome tries to mount everything. I have
an OCFS2 file system on a disk but the cluster isn't set up.

> My only quibble with the patch would be that ocfs2_orphan_scan_init()
> should be called before ocfs2_recovery_init(). Else we'll encounter the
> same problem if say ocfs2_recovery_init() fails.

Yup, you're right. Fixed version attached.

-Jeff

--
Jeff Mahoney
SuSE Labs
-------------- next part --------------
An embedded and charset-unspecified text was scrubbed...
Name: ocfs2-orphan-scan-fixup
Url: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20090707/92329fdb/attachment.pl 
-------------- next part --------------
A non-text attachment was scrubbed...
Name: signature.asc
Type: application/pgp-signature
Size: 257 bytes
Desc: OpenPGP digital signature
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20090707/92329fdb/attachment.bin 
