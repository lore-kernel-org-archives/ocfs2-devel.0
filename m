From: Manish Singh <manish.singh@oracle.com>
Date: Thu Jan 29 18:19:17 2004
Subject: [Ocfs2-devel] Re: Playing with OCFS2
In-Reply-To: <50D19C3AC815734C9E19FE4C4F6128A6178026@orsmsx403.jf.intel.com>
References: <50D19C3AC815734C9E19FE4C4F6128A6178026@orsmsx403.jf.intel.com>
Message-ID: <20040130001905.GC10332@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Jan 29, 2004 at 03:21:58PM -0800, Villalovos, John L wrote:
> I just took the latest version of OCFS2 code from Subversions today.
> 
> I am using a Fedora Core 1 system with all updates applied.
> 
> I am using a Firewire Maxtor drive to put it on.  Currently only testing
> with one computer and one drive.
> 
> I was able to build the OCFS2 and OCFS-TOOLS components with no
> problems.
> 
> I copied the ocfs2.o module to my local /lib/modules... Directory.
> 
> I ran:
> 	mkfs.ocfs -F -b 128 -L ocfs-test -m /ocfs /dev/sda1
> 	(not sure why mkfs.ocfs wants to know where the partition will
> be mounted???)
> 
> I ran:
> 	ocfstool and created my /etc/ocfs.conf
> 
> I then ran:
> 	load_ocfs2 and it complained about ip_port_v2 missing.  So I
> created an ip_port_v2 entry with a value of 7002.
> 
> Re-ran:
> 	load_ocfs2 and the driver loaded.
> 
> I then tried to mount the volume:
> 	mount -t ocfs /dev/sda1 /ocfs
> 
> 	waited for awhile and it returned but no drive was mounted :(
> 
> So I'm not sure what I did wrong.
> 
> Any suggestions would be appreciated.

The filesystem type for OCFS2 is "ocfs2", not "ocfs". Not sure why it would
take a long time with "ocfs" though..

Try with "ocfs2" and see what happens.

-Manish
