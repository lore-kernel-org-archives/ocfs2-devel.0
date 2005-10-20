From: Lars Marowsky-Bree <lmb@suse.de>
Date: Thu Oct 20 10:45:27 2005
Subject: [Ocfs2-devel] [RFC] Integration with external clustering
In-Reply-To: <20051020154244.GD11488@ca-server1.us.oracle.com>
References: <43556F8B.3060105@suse.com>
	<20051018221849.GN11488@ca-server1.us.oracle.com>
	<20051018230323.GE2813@marowsky-bree.de>
	<20051018232752.GO11488@ca-server1.us.oracle.com>
	<20051019132624.GI24589@marowsky-bree.de>
	<4356BBE8.2080904@suse.com>
	<20051020102358.GB11726@marowsky-bree.de>
	<20051020150341.GC11488@ca-server1.us.oracle.com>
	<20051020152606.GB16745@redhat.com>
	<20051020154244.GD11488@ca-server1.us.oracle.com>
Message-ID: <20051020154519.GO11726@marowsky-bree.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2005-10-20T08:42:44, Joel Becker <Joel.Becker@oracle.com> wrote:

> 	Hehe, when you said "mount process..." in your description, I
> assumed mount.gfs :-)  You might want to rip off the
> generic-mount-option-parsing code from mount.ocfs2 (which we ripped off
> from mount.smb).

So that settles how to resolve this. How boring! A solved problem. ;-)


Sincerely,
    Lars Marowsky-Br?e <lmb@suse.de>

-- 
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business	 -- Charles Darwin
"Ignorance more frequently begets confidence than does knowledge"
