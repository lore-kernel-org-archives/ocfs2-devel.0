From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 27 Feb 2009 18:31:01 -0800
Subject: [Ocfs2-devel] [PATCH 1/1] Patch to move ocfs2_slot_info
	to	slot_map.h
In-Reply-To: <1235786454-17019-2-git-send-email-srinivas.eeda@oracle.com>
References: <1235786454-17019-1-git-send-email-srinivas.eeda@oracle.com>
	<1235786454-17019-2-git-send-email-srinivas.eeda@oracle.com>
Message-ID: <20090228023101.GL10695@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Feb 27, 2009 at 06:00:54PM -0800, Srinivas Eeda wrote:
> This patch is required to access slot_info struct for a patch that recovers
> orphans from offline slots.

	Looking at your later code, it really looks like you need a set
of accessor functions.  There's no reason to expose slot_info in the
header.

Joel

-- 

"You must remember this:
 A kiss is just a kiss,
 A sigh is just a sigh.
 The fundamental rules apply
 As time goes by."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
