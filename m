Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3162C63797
	for <ocfs2-devel@archiver.kernel.org>; Tue, 17 Jan 2023 05:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=c5LxfycgoxEpvTxctji1ePL23pYnbs4FxikK7uWKmeo=;
 b=A7eEUuD8LU9/0KXyOxOC8NuWolgptvb/4WGseY4f17quelkhGXvVT3H/83lddLM3wC4eUus6m/VO
   t5fNaD3F5lsoLi9cWFI4uE53qnPce2DVxlMfJgSFuT/kAdJumGpKJ8U5Mm24HQiT6rMsM29cnvGs
   VFyhHNFIZsZp0tOAZ7ECinrEY8FS2lKmUSv7mBGhRBv7LEpkYwd8iT/G3S+ztaI9upXI3bIzLvAt
   UGg9hv+r8jnu2LbAaCiswD7vSzLm1amehboYcX/u2MoZd1oWBTryukdHhSp7Q/o0KAznXLxZXNDV
   4fY1EXs+n/+lUTnoKlrmlhC6wh47vJtjHEX1Pw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=c5LxfycgoxEpvTxctji1ePL23pYnbs4FxikK7uWKmeo=;
 b=hiro4IaDqXnbsztqhz4GD3dV+UvVKFdG+zx6YnrkfeJ3UTjqJvDop+mmb/orJheXvdJq1kaFHQVy
   9L0juXvbol8ymGuX1B+4vnUoCJFsSNpk/WhhXE6WttKoLoQjjRA3Z8lXr7oH0PBgVPgJPep8HcJ0
   hdXc7MM7hyUGgIufScZZUF4obfrHbJbq0YomJzeLdyLmu++Tsq7unuYZY0cQSbSaw9wQm2Efg1wk
   j3TccwP6aSs+xE2CdBt4Ssf1mxpj5OikhXvm5E+rC+JmkMXPbLQhsRiWtXFn8ctUHhsuTrf20ymV
   4OJKticZjWR1sAFWGdLXkUKX1RhL+uqi1AovYg==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221212 64bit (built Dec 12
 2022))
 with ESMTPS id <0ROM0040Z8HF2E50@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 17 Jan 2023 05:56:03 +0000 (GMT)
Date: Tue, 17 Jan 2023 06:55:46 +0100
To: Andrew Morton <akpm@linux-foundation.org>
Message-id: <20230117055546.GA13795@lst.de>
References: <20230116085523.2343176-1-hch@lst.de> <Y8W7dULuW5oFGm/J@ZenIV>
 <20230116133011.81f6e4e42805ed47aa61270d@linux-foundation.org>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20230116133011.81f6e4e42805ed47aa61270d@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Source-IP: 213.95.11.211
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10592
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=187
 lowpriorityscore=0 spamscore=0 suspectscore=0 mlxlogscore=616 impostorscore=0
 mlxscore=0 malwarescore=0 bulkscore=0 adultscore=0 phishscore=0
 priorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301170046
Cc: Evgeniy Dushistov <dushistov@mail.ru>, linux-mm@kvack.org,
 Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] remove most callers of write_one_page
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.15
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/options/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel/>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
From: Christoph Hellwig via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Christoph Hellwig <hch@lst.de>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: verein.lst.de
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-GUID: 3hthDcHN3CFL5FOFNh1HIAxd0lFWPijX
X-Proofpoint-ORIG-GUID: 3hthDcHN3CFL5FOFNh1HIAxd0lFWPijX
Reporting-Meta:
 AAGm7KKf5hizEwBIZj1LUpOpiyInqC27a+PFWJb3Q6wuS7rNzKE5qFUUpbtSDYSl
 /Rwk5TCveOeRmWjX1iPdvOJQhcBKg28acVkCFA09huur+cEs2Uobuok3NB9Lcr+w
 omVjb7Pd1UBlxI3/D291/+NhFg5QV3lXg4trzDhhJt5OHrd0/3qw7rPvQHcc8+01
 AO82L1NWoGBZu0tkuSWBpmA6cLGq7rPqA0SmsSHmO729HOvYPzf+/6E+pubZpJop
 H8kDrPh3mKol53ZF6gsCZ9/jSVX+dQUcMVRIN0bDc8qo5DchcTfK/4a6vh9k+p6X
 /Vlz4+drrplMdbqj3aTIxjz4iL/J1S9Mj5QBMh9MTxH6x7NYSyGtYf5D9rmTZuWQ
 YNA9uS0bGdtatICWOG6+FEvwFsFcoPaHGXFxJ1IOopfRp1wk8DgDmnw6NxE08BjY
 LGLQg09cqZ5jAEla64r7NMUHb2A2+rOKXF1/yG/aQxTFUinO34oI+sBzYf2WVgxu
 OBMSWyWe+YhL1grfj/QSzEjcPB3cz590xo27DOREZLs=

On Mon, Jan 16, 2023 at 01:30:11PM -0800, Andrew Morton wrote:
> On Mon, 16 Jan 2023 21:02:45 +0000 Al Viro <viro@zeniv.linux.org.uk> wrote:
> 
> > OK...  Mind if I grab minix/sysv/ufs into a branch in vfs.git?
> > There's a pile of kmap_local() stuff that that would interfere with
> > that and I'd rather have it in one place...
> 
> Please grab the whole series in that case?

After dropping the last patch that removes write_one_page they are
independent, so splitting is fine with me, as is Al picking all of
them up.  Note that minix probably needs the same update for the
set_link fix as Jan pointed out for ext2.

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
