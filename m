From: Mark Fasheh <mfasheh@suse.com>
Date: Wed, 5 Nov 2008 16:27:33 -0800
Subject: [Ocfs2-devel] [PATCH 27/29] ocfs2: Implement quota syncing
	thread
In-Reply-To: <1224886104833-git-send-email-jack@suse.cz>
References: <122488610212-git-send-email-jack@suse.cz>
	<1224886104833-git-send-email-jack@suse.cz>
Message-ID: <20081106002733.GY15154@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Sat, Oct 25, 2008 at 12:08:20AM +0200, Jan Kara wrote:
> This patch implements functions and timer setup which handles periodic
> syncing of locally cached quota information to global quota file.

This too looks good.
	--Mark

--
Mark Fasheh
