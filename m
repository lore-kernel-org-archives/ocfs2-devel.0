From: Mark Fasheh <mfasheh@suse.com>
Date: Thu, 30 Oct 2008 16:51:27 -0700
Subject: [Ocfs2-devel] [PATCH 21/29] ocfs2: Fix checking of return value
	of new_inode()
In-Reply-To: <12248861041207-git-send-email-jack@suse.cz>
References: <122488610212-git-send-email-jack@suse.cz>
	<12248861041207-git-send-email-jack@suse.cz>
Message-ID: <20081030235127.GN15154@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Sat, Oct 25, 2008 at 12:08:14AM +0200, Jan Kara wrote:
> new_inode() does not return ERR_PTR() but NULL in case of failure. Correct
> checking of the return value.

This one also I'm carrying now.
	--Mark

--
Mark Fasheh
