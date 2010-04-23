From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 23 Apr 2010 15:04:35 -0700
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: Make nointr a default mount
	option
In-Reply-To: <1271206831-3203-2-git-send-email-sunil.mushran@oracle.com>
References: <1271206831-3203-1-git-send-email-sunil.mushran@oracle.com>
	<1271206831-3203-2-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20100423220434.GE8330@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Apr 13, 2010 at 06:00:31PM -0700, Sunil Mushran wrote:
> OCFS2 has never really supported intr. This patch acknowledges this reality
> and makes nointr the default mount option. In a later patch, we intend to
> support intr.
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>

	A modified version of this patch is now in the 'merge-window'
branch of ocfs2.git.

Joel
 

-- 

"Any man who is under 30, and is not a liberal, has not heart;
 and any man who is over 30, and is not a conservative, has no brains."
         - Sir Winston Churchill 

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
