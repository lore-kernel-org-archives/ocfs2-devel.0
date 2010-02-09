From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 8 Feb 2010 16:50:24 -0800
Subject: [Ocfs2-devel] [PATCH 2/2] Ocfs2: Fix punching hole codes to
 correctly do CoW during cluster zeroing.
In-Reply-To: <1265366732-15895-2-git-send-email-tristan.ye@oracle.com>
References: <1265366732-15895-1-git-send-email-tristan.ye@oracle.com>
	<1265366732-15895-2-git-send-email-tristan.ye@oracle.com>
Message-ID: <20100209005024.GG1832@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Feb 05, 2010 at 06:45:32PM +0800, Tristan Ye wrote:
> Based on the former patch of truncating optimization, bugfix for refcount on
> punching holes can be fairly easy and straightforward since most of work we
> should take into account for refcounting have been completed already in func
> ocfs2_remove_btree_range(), which is also being used by our truncating codes.
> 
> The patch just did CoW for reflinks when a hole is being punched whose start
> and end offset were within one cluster, which means partial zeroing for a cluster
> will be performed soon.
> 
> The patch has been tested fixing the following bug:
> 
> http://oss.oracle.com/bugzilla/show_bug.cgi?id=1216

	This patch is good.

Joel

-- 

"Here's something to think about:  How come you never see a headline
 like ``Psychic Wins Lottery''?"
	- Jay Leno

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
