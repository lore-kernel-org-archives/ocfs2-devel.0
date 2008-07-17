From: Mark Fasheh <mfasheh@suse.com>
Date: Thu, 17 Jul 2008 11:11:03 -0700
Subject: [Ocfs2-devel] [PATCH 08/15] ocfs2: Add extended attribute
	support v2
In-Reply-To: <487F1335.4020303@oracle.com>
References: <48648B3E.6050808@oracle.com>
	<1214551656-22529-1-git-send-email-tiger.yang@oracle.com>
	<1214551656-22529-2-git-send-email-tiger.yang@oracle.com>
	<20080711194754.GA9557@wotan.suse.de> <487F1335.4020303@oracle.com>
Message-ID: <20080717181103.GI28014@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Jul 17, 2008 at 05:39:01PM +0800, Tiger Yang wrote:
> Do we really need take space(32 bytes) in superblock to store this hash 
> value? For the space in superblock is very precious.

No, we don't need 32 bytes. We need to only use 32 *bits*. Mkfs.ocfs2 should
calculate the seed value as you already do in kernel and store it there.
That way uuid can change, but the hash stays the same, ensuring that we'll
be able to find xattrs on a volume that has been dd'd or snapshotted.
	--Mark

--
Mark Fasheh
