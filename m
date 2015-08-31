From: Mark Fasheh <mfasheh@suse.de>
Date: Mon, 31 Aug 2015 13:13:05 -0700
Subject: [Ocfs2-devel] [patch 19/28] ocfs2: neaten do_error,
	ocfs2_error and ocfs2_abort
In-Reply-To: <55de39bb./OZwbsoqvDpz/T2v%akpm@linux-foundation.org>
References: <55de39bb./OZwbsoqvDpz/T2v%akpm@linux-foundation.org>
Message-ID: <20150831201305.GY1145@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Aug 26, 2015 at 03:12:11PM -0700, Andrew Morton wrote:
> From: Joe Perches <joe@perches.com>
> Subject: ocfs2: neaten do_error, ocfs2_error and ocfs2_abort
> 
> These uses sometimes do and sometimes don't have '\n' terminations.  Make
> the uses consistently use '\n' terminations and remove the newline from
> the functions.
> 
> Miscellanea:
> 
> o Coalesce formats
> o Realign arguments
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> Cc: Mark Fasheh <mfasheh@suse.com>
> Cc: Joel Becker <jlbec@evilplan.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Reviewed-by: Mark Fasheh <mfasheh@suse.de>
	--Mark

--
Mark Fasheh
