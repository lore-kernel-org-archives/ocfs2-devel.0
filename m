From: Lars Marowsky-Bree <lmb@suse.de>
Date: Mon Oct 24 06:41:15 2005
Subject: [Ocfs2-devel] [RFC] Integration with external clustering
In-Reply-To: <9FBDF3A9-27F7-4F4F-BE47-47174A31A586@suse.de>
References: <20051018230323.GE2813@marowsky-bree.de>
	<20051018232752.GO11488@ca-server1.us.oracle.com>
	<20051019132624.GI24589@marowsky-bree.de>
	<4356BBE8.2080904@suse.com>
	<20051020102358.GB11726@marowsky-bree.de>
	<20051020150341.GC11488@ca-server1.us.oracle.com>
	<20051020152606.GB16745@redhat.com>
	<20051020154244.GD11488@ca-server1.us.oracle.com>
	<20051020154519.GO11726@marowsky-bree.de>
	<9FBDF3A9-27F7-4F4F-BE47-47174A31A586@suse.de>
Message-ID: <20051024114108.GJ19508@marowsky-bree.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2005-10-21T11:05:37, Andrew Beekhof <abeekhof@suse.de> wrote:

> for future reference, in the context of hb2 the callout will have to  
> either:
> - create a placement constraint to put the new clone on the correct node
> - increase the number of clones
> - somehow figure out if the new clone would ever be started  
> (otherwise it may block forever)

In that case the clone will still be orphaned/inactive after the cluster
has reached S_IDLE again.

> - wait for the new clone to be started
> 
> or, do nothing (if invoked by hb2 directly)


Sincerely,
    Lars Marowsky-Br?e <lmb@suse.de>

-- 
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business	 -- Charles Darwin
"Ignorance more frequently begets confidence than does knowledge"
