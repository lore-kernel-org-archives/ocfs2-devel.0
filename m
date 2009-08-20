From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 20 Aug 2009 16:59:54 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Add missing lock name
In-Reply-To: <1250785612-17385-1-git-send-email-jack@suse.cz>
References: <1250785612-17385-1-git-send-email-jack@suse.cz>
Message-ID: <20090820235954.GD10558@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Aug 20, 2009 at 06:26:52PM +0200, Jan Kara wrote:
> There is missing name for NFSSync cluster lock. This makes lockdep unhappy
> because we end up passing NULL to lockdep when initializing lock key. Fix it.

This is now part of the fixes branch of ocfs2.git.

Joel

-- 

"Not everything that can be counted counts, and not everything
 that counts can be counted."
        - Albert Einstein 

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
