From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed Jan  2 14:58:33 2008
Subject: [Ocfs2-devel] [PATCH 5/7] ocfs2: De-magic the in-memory slot map.
In-Reply-To: <20080101010929.GC23506@ca-server1.us.oracle.com>
References: <1197004787-15344-1-git-send-email-joel.becker@oracle.com>
	<1197004787-15344-6-git-send-email-joel.becker@oracle.com>
	<20080101010929.GC23506@ca-server1.us.oracle.com>
Message-ID: <20080102225815.GB8779@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Dec 31, 2007 at 05:09:29PM -0800, Mark Fasheh wrote:
> >  	bytes_needed = osb->max_slots * sizeof(__le16);
> > -	if (bytes_needed < i_size_read(inode)) {
> > +	if (bytes_needed > i_size_read(inode)) {
> 
> Why wasn't this just fixed in the previous patch?

	Probably due to testing flow.  It's moved now.

Joel

-- 

"If the human brain were so simple we could understand it, we would
 be so simple that we could not."
	- W. A. Clouston

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
