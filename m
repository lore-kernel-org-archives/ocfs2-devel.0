From: Mark Fasheh <mfasheh@suse.com>
Date: Wed, 3 Jun 2009 14:05:29 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Correct ordering of ip_alloc_sem
	and localloc locks for directories
In-Reply-To: <1243945445-25847-6-git-send-email-jack@suse.cz>
References: <1243945445-25847-1-git-send-email-jack@suse.cz>
	<1243945445-25847-6-git-send-email-jack@suse.cz>
Message-ID: <20090603210529.GF10980@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Jun 02, 2009 at 02:24:03PM +0200, Jan Kara wrote:
> We use ordering ip_alloc_sem -> local alloc locks in ocfs2_write_begin().
> So change lock ordering in ocfs2_extend_dir() and ocfs2_expand_inline_dir()
> to also use this lock ordering.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
Acked-by: Mark Fasheh <mfasheh@suse.com>

--
Mark Fasheh
