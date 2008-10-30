From: Mark Fasheh <mfasheh@suse.com>
Date: Thu, 30 Oct 2008 16:52:34 -0700
Subject: [Ocfs2-devel] [PATCH 22/29] ocfs2: Let inode be really deleted
	when ocfs2_mknod_locked() fails
In-Reply-To: <12248861043323-git-send-email-jack@suse.cz>
References: <122488610212-git-send-email-jack@suse.cz>
	<12248861043323-git-send-email-jack@suse.cz>
Message-ID: <20081030235234.GO15154@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Sat, Oct 25, 2008 at 12:08:15AM +0200, Jan Kara wrote:
> We forgot to set i_nlink to 0 when returning due to error from ocfs2_mknod_locked()
> and thus inode was not properly released via ocfs2_delete_inode() (e.g. claimed
> space was not released). Fix it.

By the way, does ocfs2_delete_inode() complain when this can't be found in
the orphan dir?
	--Mark

--
Mark Fasheh
