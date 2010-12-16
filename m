From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 16 Dec 2010 00:52:49 -0800
Subject: [Ocfs2-devel] Pin the configfs items while cluster is active
In-Reply-To: <1292364871-18461-1-git-send-email-sunil.mushran@oracle.com>
References: <1292364871-18461-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20101216085249.GO15545@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Dec 14, 2010 at 02:14:26PM -0800, Sunil Mushran wrote:
> 
> All,
> 
> This patch series is long over-due. configfs added the ability to pin items
> in commit 631d1febab8e546e3bb800bdfe2c212b8adf87de (Jun 2007). The following
> patches make use of it in the O2CB cluster stack to pin both the node and
> heartbeat items.
> 
> This has been tested for both local and global heartbeat modes.

This series is now in the merge-window branch of ocfs2.git.

> 
> Sunil

-- 

"Only a life lived for others is a life worth while."
							-Albert Einstein  

Joel Becker
Senior Development Manager
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
