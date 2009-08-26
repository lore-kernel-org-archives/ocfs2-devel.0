From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 25 Aug 2009 21:39:16 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: __ocfs2_abort() should not
 enable panic for local mounts
In-Reply-To: <1250720161-29360-1-git-send-email-sunil.mushran@oracle.com>
References: <1250720161-29360-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20090826043916.GB21669@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Aug 19, 2009 at 03:16:01PM -0700, Sunil Mushran wrote:
> In a clustered setup, we have to panic the box on journal abort. This is
> because we don't have the facility to go hard readonly. With hard ro, another
> node would detect node failure and initiate recovery.
> 
> Having said that, we shouldn't force panic if the volume is mounted locally.
> This patch defers the handling to the mount option, errors.
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>

This is now in the merge-window branch of ocfs2.git.

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
