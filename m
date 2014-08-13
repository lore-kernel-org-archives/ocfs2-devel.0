From: Matthew Huff <mhuff@ox.com>
Date: Wed, 13 Aug 2014 15:52:39 +0000
Subject: [Ocfs2-devel] [Ocfs2-users] Does any other company and
 production use the ocfs2?
In-Reply-To: <49C39678-D56E-4B3E-ACDD-A2991F03FF40@oracle.com>
References: <53E97568.3080805@huawei.com>
	<a083f033f76e4bc7872255393bda8f0c@pur-vm-exch13n2.ox.com>
	<49C39678-D56E-4B3E-ACDD-A2991F03FF40@oracle.com>
Message-ID: <7c85f98c4cb54863a092b29dc45053f1@pur-vm-exch13n2.ox.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Understood.

Besides the politics, is there a reason Oracle can't re-add the code to RHEL/SUSE as a rpm? Not having ocfs2 available is not going to lead us to use Oracle Linux, rather we are much more likely to use GFS or Veritas. We have a large implementation of HP hardware / RHEL, and have standard monitoring tools, scripts, etc to build / manage machines, and would be very unlikely to introduce another OS into the mix.

----
Matthew Huff???????????? | 1 Manhattanville Rd
Director of Operations?? | Purchase, NY 10577
OTA Management LLC??? ???| Phone: 914-460-4039

-----Original Message-----
From: Avi Miller [mailto:avi.miller at oracle.com] 
Sent: Tuesday, August 12, 2014 4:49 PM
To: Matthew Huff
Cc: Jensen; ocfs2-users at oss.oracle.com; ocfs2-devel at oss.oracle.com
Subject: Re: [Ocfs2-devel] [Ocfs2-users] Does any other company and production use the ocfs2?

Hi,

On 13 Aug 2014, at 1:13 am, Matthew Huff <mhuff@ox.com> wrote:

> But since Oracle stopped upgrading it except for Oracle Linux, we migrated to ext4 (we didn't need the cluster feature, just wanted the direct i/o), but ext4 is working fine for us now.

Note that we didn't stop upgrading it: it's in the mainline kernel source. Red Hat actively remove OCFS2 from the kernel in their distribution (in favour of GFS2) and we just stopped providing external RPMs for OCFS2. In the case of Oracle Linux, we just don't remove the OCFS2 code from mainline when building our own kernels.

--
Oracle <http://www.oracle.com>
Avi Miller | Product Management Director | +61 (3) 8616 3496
Oracle Linux and Virtualization
417 St Kilda Road, Melbourne, Victoria 3004 Australia
