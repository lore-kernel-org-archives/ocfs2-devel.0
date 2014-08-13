From: Avi Miller <avi.miller@oracle.com>
Date: Thu, 14 Aug 2014 07:22:01 +1000
Subject: [Ocfs2-devel] [Ocfs2-users] Does any other company and
	production use the ocfs2?
In-Reply-To: <7c85f98c4cb54863a092b29dc45053f1@pur-vm-exch13n2.ox.com>
References: <53E97568.3080805@huawei.com>
	<a083f033f76e4bc7872255393bda8f0c@pur-vm-exch13n2.ox.com>
	<49C39678-D56E-4B3E-ACDD-A2991F03FF40@oracle.com>
	<7c85f98c4cb54863a092b29dc45053f1@pur-vm-exch13n2.ox.com>
Message-ID: <E3C62F85-1782-4159-B592-D48BD91F1473@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

On 14 Aug 2014, at 1:52 am, Matthew Huff <mhuff@ox.com> wrote:

> Besides the politics, is there a reason Oracle can't re-add the code to RHEL/SUSE as a rpm? 

SUSE retains OCFS2 support in their kernel as they use it as part of their HA stack (with DRBD/Corosync/Pacemaker). At the moment, we have no plans to create OCFS2 RPMs for RHEL6/7, as there is no longer a business case for it: RDBMS (the initial primary Oracle consumer of OCFS2) has deprecated OCFS2 in favour of ASM/ACFS. The only remaining product within Oracle that uses OCFS2 extensively is Oracle VM.

--
Oracle <http://www.oracle.com>
Avi Miller | Product Management Director | +61 (3) 8616 3496
Oracle Linux and Virtualization
417 St Kilda Road, Melbourne, Victoria 3004 Australia
