From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 18 Feb 2009 09:43:50 -0800
Subject: [Ocfs2-devel] [PATCH 1/1] OCFS2: anti stale inode for nfs (V3)
In-Reply-To: <499BC715.2000701@oracle.com>
References: <200902171255.n1HCsxeo017544@acsinet13.oracle.com>
	<20090218013700.GA26431@mail.oracle.com>
	<499BC715.2000701@oracle.com>
Message-ID: <20090218174350.GB9020@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Feb 18, 2009 at 04:30:13PM +0800, Wengang Wang wrote:
>>> +	if (suballoc_slot)
>>> +		*suballoc_slot = le16_to_cpu(inode_fe->i_suballoc_slot);
>> 	Probably want to validate that suballoc_slot is within the range
>> of valid slot numbers.  Just in case.
> in what case could the suballoc_slot be out of range?

	Filesystem corruption or a bad NFS handle of some sort.  It's
easy to check that i_suballoc_slot is either OCFS2_INVALID_SLOT or
within osb->max_slots.

Joel

-- 

Dort wo man B?cher verbrennt, verbrennt man am Ende auch Mensch.
(Wherever they burn books, they will also end up burning people.)
	- Heinrich Heine

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
