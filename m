Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53582C54EBD
	for <ocfs2-devel@archiver.kernel.org>; Thu, 12 Jan 2023 08:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=0ZrRoq4YmwoEtg8yKNvtcLQ6CYl3p6GSAJuneX0ms2U=;
 b=eQrD95IalQgmdTKnRvJeIoERmrz5TzmXP7+GhUiM2ObxT0daRI1/atsOhZfBkcsirnb2wdfA7b39
   zTrya2xYqdgffwoUVm75uSdoaDB1c6oKATCfxQVkfMZPpim0cpzc9O3c5qGY4maRpP3IrGcMcpWK
   BYIf3MhrBzeSYaREaSnbrnPtYvpKp9FM1EPeOsTwkbiOtz9Dbno86r1yxQ8sdFNS57j+/k+8O+Hz
   /2K429UcN/udYRT4RbbpzjUBb8fpKPNMpIxSvLZ/aL/OPb63qrXPAlVH+fFpxQIL5qkWqEY0tILR
   jXXNfsoRpNVnkfrOuqIx60kTkuk448D1FSf2CA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=0ZrRoq4YmwoEtg8yKNvtcLQ6CYl3p6GSAJuneX0ms2U=;
 b=biuLFU5dLSMi3WXbmmp/woqLOgmEzO0Y/RwcL8n5DOojOBhAi5DbVsez4eabm+wrF2AHp3wpHWMl
   hB0I6cXe7gEqTq6JwCJG0FLDKYJ2zP2bOqPpKzrGeoFTr7b7p7o+lfb8Jqy2jTcz5EBdby8VKbu2
   WYXW+VhjX8JApbSf6eP9JOH9tW142v2bgBg1f+qek0xzl4ke1+sL3Sye1yTSpoc0/cbHcGiGgjj0
   D6qkncWSDbKSWDYk68qyMUDIEliZ+0vcd0nZgiQf56e5qV/fsXczB28gp1q2cAraHfoZg/LcbZBM
   e7QPDyP+PfCS7rZ5m1yfFddqrGQPGcBHEf9Lqw==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221212 64bit (built Dec 12
 2022))
 with ESMTPS id <0ROD009MI513CM10@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 12 Jan 2023 08:03:03 +0000 (GMT)
Date: Thu, 12 Jan 2023 09:02:32 +0100
To: David Sterba <dsterba@suse.cz>
Message-id: <20230112080232.GA12920@lst.de>
References: <20230108165645.381077-1-hch@lst.de>
 <20230109195309.GU11562@twin.jikos.cz> <20230110081653.GA11947@lst.de>
 <20230110130042.GA11562@suse.cz> <20230110153216.GA10159@lst.de>
 <20230111192027.GJ11562@twin.jikos.cz>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20230111192027.GJ11562@twin.jikos.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Source-IP: 213.95.11.211
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10587
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxlogscore=461
 spamscore=0 phishscore=0 suspectscore=0 priorityscore=0 bulkscore=0
 impostorscore=0 mlxscore=0 lowpriorityscore=0 malwarescore=0 adultscore=0
 clxscore=253 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301120056
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net,
 Evgeniy Dushistov <dushistov@mail.ru>, Josef Bacik <josef@toxicpanda.com>,
 linux-mm@kvack.org, Chris Mason <clm@fb.com>, ocfs2-devel@oss.oracle.com,
 David Sterba <dsterba@suse.com>, linux-fsdevel@vger.kernel.org,
 linux-btrfs@vger.kernel.org
Subject: Re: [Ocfs2-devel] remove write_one_page / folio_write_one
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
X-Proofpoint-ORIG-GUID: wgBoXXXgeW6ajRx0GXPP6SPWYbFNOSP3
X-Proofpoint-GUID: wgBoXXXgeW6ajRx0GXPP6SPWYbFNOSP3
Reporting-Meta:
 AAG+wrohAanGhGa1rJnsqMMVTXAcRmnvGgm8X2F8YcR4JaFJBEj6j6aWHbbImJRD
 ZRmdeW5NcSSwt7mOnDZt00vh9oQogaOpAkRuwUc7o/E8j4VlA2qpd6IzpdPTHHjS
 kBcu+IBapZKUlyJUq8D6UvFg+o8bR48+eSHT1kplEkhdQ23kvBx+qTA4hRwFkDh1
 sfflml5/zdFjD7P4/LrdkPrLXVMx2+s2aGHKbr0NhquXyr3IGEWHfCaQu3aEaPDs
 TS7+xS7bb99zVKXt0sE9P1dLS8P9a0EYp9woZQ0H/CmhOgbHIp5w2lEW0zz7Gdby
 j5wwV0GPINVJohoVKWnru9CONhMNGg1pXNwrakAQrFrtXLncT7ylDIwDlsr5MZBL
 A0l42SUGimLNlYfzgQtKXGjJVReOWC6T7f/Z6sAlDl1uPfuOdYnrsNJHBDzwLUcu
 xQ1G5V6TGSOTRkxsnVhJkxLyc3AsQYVKC6QujD2jlQjJzrBNk12HuRP/ZukAdO6+
 VrkBHdzJ2DL0heXpDfyEMSZ6YzWbho3P1BovL7Wi7baA

On Wed, Jan 11, 2023 at 08:20:27PM +0100, David Sterba wrote:
> Ok then, to make it easier for the folio changes I'll send the two btrfs
> patches next week. As the rest of the series does not depend on it,
> I don't see the need to let them all go via the mm tree.

The last patch depends on the btrfs changes as it removes write_one_page
entirely.

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
