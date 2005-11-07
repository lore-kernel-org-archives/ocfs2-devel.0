From: Lars Marowsky-Bree <lmb@suse.de>
Date: Mon Nov  7 06:08:18 2005
Subject: [Ocfs2-devel] [RFC] Integration with external clustering
In-Reply-To: <20051107050117.GA17440@lst.de>
References: <20051018232752.GO11488@ca-server1.us.oracle.com>
	<20051019132624.GI24589@marowsky-bree.de>
	<4356BBE8.2080904@suse.com>
	<20051020102358.GB11726@marowsky-bree.de>
	<20051020150341.GC11488@ca-server1.us.oracle.com>
	<20051020152606.GB16745@redhat.com>
	<20051020154244.GD11488@ca-server1.us.oracle.com>
	<20051021090937.GA30904@lst.de> <4358A6C1.C5C7.00CF.0@novell.com>
	<20051107050117.GA17440@lst.de>
Message-ID: <20051107120805.GC22055@marowsky-bree.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2005-11-07T06:01:17, Christoph Hellwig <hch@lst.de> wrote:

> Umm, no.  not at all :) what I meant was routines for parsing mount
> options so far.  when we find additional code useful for mount helpers
> we can move it there aswell, but I'm not interested in new functionally,
> especially not such things.

Well, given that it can be implemented via the same hooks entirely in
user-space, everyone can be happy.



-- 
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business	 -- Charles Darwin
"Ignorance more frequently begets confidence than does knowledge"
