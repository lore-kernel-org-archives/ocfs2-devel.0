From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 5 Feb 2010 15:24:44 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Fix contiguousness check in
 ocfs2_try_to_merge_extent_map()
In-Reply-To: <4B6BE443.5000307@gmail.com>
References: <4B6BE443.5000307@gmail.com>
Message-ID: <20100205232443.GF3416@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Mark Fasheh <mfasheh@suse.com>, tao.ma@oracle.com, ocfs2-devel@oss.oracle.com, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>

On Fri, Feb 05, 2010 at 10:26:27AM +0100, Roel Kluin wrote:
> The wrong member was compared in the continguousness check.
> 
> Acked-by: Tao Ma <tao.ma@oracle.com>
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

This patch is now in the fixes branch of ocfs2.git.

Joel

-- 

"Sometimes when reading Goethe I have the paralyzing suspicion
 that he is trying to be funny."
         - Guy Davenport

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
