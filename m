From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Tue Jan  8 14:49:35 2008
Subject: [Ocfs2-devel] [PATCH 06/30] ocfs2: Include
	do_sync_mapping_range() from mainline
In-Reply-To: <4783E96F.3030307@oracle.com>
References: <1199388006-32658-1-git-send-email-sunil.mushran@oracle.com>
	<1199388006-32658-5-git-send-email-sunil.mushran@oracle.com>
	<20080108211920.GF23506@ca-server1.us.oracle.com>
	<4783E96F.3030307@oracle.com>
Message-ID: <20080108224747.GL23506@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Jan 08, 2008 at 01:21:51PM -0800, Sunil Mushran wrote:
> FLAGS_alloc.o += -DNO_SYNC_MAPPING_RANGE
>
> It's only included with alloc.c.

And if we ever need to call it from another file?
	--Mark

--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com
