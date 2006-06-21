From: Brian Long <brilong@cisco.com>
Date: Wed, 21 Jun 2006 08:44:36 -0400
Subject: [Ocfs2-devel] OCFS2 and RHEL 4 largesmp kernel?
Message-ID: <1150893877.5288.12.camel@brilong-lnx>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hello,

I was wondering if you plan to compile and or qualify the new "largesmp"
kernel that Red Hat ships with RHEL 4 Update 3 and beyond?  This is the
new kernel that supports > 8 x86_64 CPU cores.  Since the changes
required to support > 8 cores broke the kABI, Red Hat decided to make a
new RPM called kernel-largesmp.

Thanks for any info.

/Brian/
-- 
       Brian Long                      |         |           |
       IT Data Center Systems          |       .|||.       .|||.
       Cisco Linux Developer           |   ..:|||||||:...:|||||||:..
       Phone: (919) 392-7363           |   C i s c o   S y s t e m s
