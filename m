From: Mark Fasheh <mfasheh@suse.com>
Date: Wed, 29 Oct 2008 16:10:46 -0700
Subject: [Ocfs2-devel] [PATCH 11/29] quota: Move quotaio_v[12].h from
	include/linux/ to fs/
In-Reply-To: <1224886103731-git-send-email-jack@suse.cz>
References: <122488610212-git-send-email-jack@suse.cz>
	<1224886103731-git-send-email-jack@suse.cz>
Message-ID: <20081029231046.GJ15154@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Sat, Oct 25, 2008 at 12:08:04AM +0200, Jan Kara wrote:
> Since these include files are used only by implementation of quota formats,
> there's no need to have them in include/linux/.

Also a good idea imho.
	--Mark

--
Mark Fasheh
