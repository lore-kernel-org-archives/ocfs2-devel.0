From: TaoMa <tao.ma@oracle.com>
Date: Wed, 20 Aug 2008 18:00:43 +0800
Subject: [Ocfs2-devel] [PATCH 0/16] OCFS2: Add extended attributes
	support. V4
In-Reply-To: <20080819231613.GC8070@wotan.suse.de>
References: <48A929A4.90103@oracle.com> <20080819231613.GC8070@wotan.suse.de>
Message-ID: <48ABEB4B.2040003@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mark Fasheh wrote:
> On Mon, Aug 18, 2008 at 03:49:56PM +0800, Tao Ma wrote:
>   
>> Hi all,
>> 	Extended attributes are used for storing POSIX ACLs, SELinux labels, 
>> and user accessible metadata. They are essential for deploying file 
>> systems exported for workgroup use via samba. The following patches
>> implement extended attributes on the OCFS2 file system.
>>     
>
> Alright, this is all merged up into the linux-next and ALL branches. By the
> way, I ran it through sparse and checkpatch, both came out clean.
>
> Any additional patches, please develop on top of this branch:
>
> http://git.kernel.org/?p=linux/kernel/git/mfasheh/ocfs2.git;a=shortlog;h=xattrs
>
> Assuming we can address any review issues that come up, this will go
> upstream in 2.6.28.
>
> So far, my checklist includes:
>   - any changes that should happen as a result of Joel's review
>   - the possibility of allowing for empty buckets, in case we want to
>     disable automatic removal of empty buckets in the future.
>   - small possibility of changing the hash function
>
> Tiger, what is the likelyhood we can get some working mkfs and debugfs
> patches soon? I'd really like to be able to run this and analyze the
> effectivenes of our scheme.
>   
Tiger already has the patch for mkfs. See
http://oss.oracle.com/pipermail/ocfs2-tools-devel/2008-August/000977.html

Regards,
Tao
