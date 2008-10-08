From: Christoph Hellwig <hch@lst.de>
Date: Wed, 8 Oct 2008 15:34:53 +0200
Subject: [Ocfs2-devel] [PATCH 13/39] ocfs2: Add extended attribute
	support
In-Reply-To: <48EC1359.6040109@oracle.com>
References: <1222293680-15451-1-git-send-email-mfasheh@suse.com>
	<1222293680-15451-14-git-send-email-mfasheh@suse.com>
	<20081002081644.GB24717@lst.de>
	<20081007220811.GG26373@wotan.suse.de>
	<48EC1359.6040109@oracle.com>
Message-ID: <20081008133453.GH25392@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tiger Yang <tiger.yang@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>, Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Wed, Oct 08, 2008 at 09:56:41AM +0800, Tiger Yang wrote:
> I have looked the patch for btrfs about this. We are different.
> Btrfs store the whole xattr name including the prefix "user." 
> "trusted.", we store index number instead of it.

I looked at the git tree and there are two users of
ocfs2_xattr_handler().

 (1) for using the ->list handler in listattr.  That's something I fixed
     in btrfs that I wanted to point you to.  The whole concept of a
     ->list handler is stupid, and it was only added as a hack for
     the tmpfs "generic" xattr support which is a mess.  Instead of
     looking up a handler that would only do the same thing anyway
     for all on-disk attributes just call the code directly and
     have a map from index to prefix (look at
     fs/xfs/linux-2.6/xfs_xattr.c for an example).  You
     also have a check for OCFS2_MOUNT_NOUSERXATTR for the user
     attributes, but that's much easier done by just checking the
     index in an if (and I'd personally just kill it completely, the
     options doesn't seem useful - but that's an unrelated bit)
 
 (2) For generating the hash.  I don't quite understand why you want to
     also hash the prefix if it's not store on disk anyway but sorted
     into the numeric buckets.
