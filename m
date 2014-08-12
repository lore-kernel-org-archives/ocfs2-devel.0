From: Avi Miller <avi.miller@oracle.com>
Date: Wed, 13 Aug 2014 06:49:27 +1000
Subject: [Ocfs2-devel] [Ocfs2-users] Does any other company and
	production use the ocfs2?
In-Reply-To: <a083f033f76e4bc7872255393bda8f0c@pur-vm-exch13n2.ox.com>
References: <53E97568.3080805@huawei.com>
	<a083f033f76e4bc7872255393bda8f0c@pur-vm-exch13n2.ox.com>
Message-ID: <49C39678-D56E-4B3E-ACDD-A2991F03FF40@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

On 13 Aug 2014, at 1:13 am, Matthew Huff <mhuff@ox.com> wrote:

> But since Oracle stopped upgrading it except for Oracle Linux, we migrated to ext4 (we didn't need the cluster feature, just wanted the direct i/o), but ext4 is working fine for us now.

Note that we didn?t stop upgrading it: it?s in the mainline kernel source. Red Hat actively remove OCFS2 from the kernel in their distribution (in favour of GFS2) and we just stopped providing external RPMs for OCFS2. In the case of Oracle Linux, we just don?t remove the OCFS2 code from mainline when building our own kernels.

--
Oracle <http://www.oracle.com>
Avi Miller | Product Management Director | +61 (3) 8616 3496
Oracle Linux and Virtualization
417 St Kilda Road, Melbourne, Victoria 3004 Australia
