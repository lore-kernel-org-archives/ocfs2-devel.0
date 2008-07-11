From: Mark Fasheh <mfasheh@suse.com>
Date: Fri, 11 Jul 2008 16:58:22 -0700
Subject: [Ocfs2-devel] [PATCH 11/15] Add xattr bucket iteration for
	large numbers of	EAs.v2
In-Reply-To: <4877F239.9090906@oracle.com>
References: <48648B3E.6050808@oracle.com>
	<20080627070217.GA20369@tma-pc2.cn.oracle.com>
	<20080711203255.GB9557@wotan.suse.de> <4877F239.9090906@oracle.com>
Message-ID: <20080711235822.GC9557@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Sat, Jul 12, 2008 at 07:52:25AM +0800, Tao Ma wrote:
> >
> >
> >
> >>+		} else
> >>+			bucket = bhs[0]->b_data;
> >>+
> >>+		xh = (struct ocfs2_xattr_header *)bucket;
> >>+		/*
> >>+		 * The real bucket num in this series of blocks is stored
> >>+		 * in the 1st bucket.
> >>+		 */
> >>+		if (i == 0)
> >>+			bucket_num = le16_to_cpu(xh->xh_reserved1);
> >
> >Do you really mean "xh_reserved1" here? If so, please just give that field 
> >a
> >useful name ;) *_reserved* usually indicates that it's unused...
> In your design doc 
> http://oss.oracle.com/osswiki/OCFS2/DesignDocs/IndexedEATrees you said 
> "We can store the current number of contiguous, non-empty buckets by 
> storing it in the 16 bit xh_reserved1 field. " So do I misread it(you 
> mean use this field and change it to another name)?

Yeah, change the name - there's no point to leaving it around as "reserved"
	--Mark

--
Mark Fasheh
