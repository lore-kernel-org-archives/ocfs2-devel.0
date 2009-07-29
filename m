From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 28 Jul 2009 18:04:35 -0700
Subject: [Ocfs2-devel] [PATCH 7/8] Add quota support to tunefs.ocfs2
In-Reply-To: <1248717216-26617-8-git-send-email-jack@suse.cz>
References: <1248717216-26617-1-git-send-email-jack@suse.cz>
	<1248717216-26617-8-git-send-email-jack@suse.cz>
Message-ID: <20090729010435.GE20595@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Jul 27, 2009 at 07:53:35PM +0200, Jan Kara wrote:
> Implement setting of quota feature via tunefs.ocfs2 and also properly
> create / delete local quota files when number of slots increases /
> decreases. Implement setting of interval in which we sync changes
> in local quota file to the global quota file.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Looks good, I think.


-- 

"Baby, even the losers
 Get luck sometimes.
 Even the losers
 Keep a little bit of pride."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
