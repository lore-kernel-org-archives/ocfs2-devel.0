From: Mark Fasheh <mfasheh@suse.com>
Date: Tue, 19 Aug 2008 16:16:13 -0700
Subject: [Ocfs2-devel] [PATCH 0/16] OCFS2: Add extended attributes
	support. V4
In-Reply-To: <48A929A4.90103@oracle.com>
References: <48A929A4.90103@oracle.com>
Message-ID: <20080819231613.GC8070@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Aug 18, 2008 at 03:49:56PM +0800, Tao Ma wrote:
> Hi all,
> 	Extended attributes are used for storing POSIX ACLs, SELinux labels, 
> and user accessible metadata. They are essential for deploying file 
> systems exported for workgroup use via samba. The following patches
> implement extended attributes on the OCFS2 file system.

Alright, this is all merged up into the linux-next and ALL branches. By the
way, I ran it through sparse and checkpatch, both came out clean.

Any additional patches, please develop on top of this branch:

http://git.kernel.org/?p=linux/kernel/git/mfasheh/ocfs2.git;a=shortlog;h=xattrs

Assuming we can address any review issues that come up, this will go
upstream in 2.6.28.

So far, my checklist includes:
  - any changes that should happen as a result of Joel's review
  - the possibility of allowing for empty buckets, in case we want to
    disable automatic removal of empty buckets in the future.
  - small possibility of changing the hash function

Tiger, what is the likelyhood we can get some working mkfs and debugfs
patches soon? I'd really like to be able to run this and analyze the
effectivenes of our scheme.


And finally, thanks guys. This is great stuff and I know it wasn't easy
getting it all going...
	--Mark

--
Mark Fasheh
