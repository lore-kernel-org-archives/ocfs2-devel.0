Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1D1DC46467
	for <ocfs2-devel@archiver.kernel.org>; Tue, 10 Jan 2023 15:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=bufPdtuWLUTgfhgUJ+XFk/dswtvZSd00z+3hvKTdCVk=;
 b=Z1qXl1HP6La/G2eXM4Jnj9978GsiFd5826Uxbl9g67GISG0BvPVDstzJy9BUuDl05zw+pH4eP7/f
   YDsqp0vXrrUxIp/U96RZleKPC/pQz1VS6LfGTu6thw5LAEInxx9CaceDuUefLrt0bisjea2Ht3nJ
   dJAzMXtoQpC3EVexb4sY8pRI9phejnT3dzNe8cNPi3U4ajWBHqUEnPyxRqW4B+zvNvwWGBfoBePH
   1NSTm/SfWKuPeu5Yl4+cBQ13rkBnoUw+eWVrgLcLrQFduAAz5fbM6No/meahhriYrsy06BVQXeVB
   8VzbrPISd3bhrKBVKYyqU00ape+EUnxOeAa1Tg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=bufPdtuWLUTgfhgUJ+XFk/dswtvZSd00z+3hvKTdCVk=;
 b=gGnxfXsdiqDaPjdC9IfS1wWudciFSZmYXnwffCuXfPEBx0cDJ3piB5h7BAtt2ZuKBkrtEOpuMpcZ
   imo8e5wdbHNB3l5//f2kYDB+lnv6hZefViajAk4+8FDMmUnDu4MhOkqtIrYh2cXjBJ9eUsDHXguA
   Z/ILqRj+DfDviWISCfxNZVvAVBDx5VDP/Km7NSSzwzYqq//rfQL2JeaWflEkS2+usqCtnSq7/8Rp
   3OTQpoti5QsT6yC/qkWGorz4+tWkVBWyHfmee6cYbJ6y92BHXjm8le8clSNAy2j4IHCJWogHW+b/
   r7VTcH6mJ3upQcI4AcNityoYlCy9NmCQlbDooA==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221212 64bit (built Dec 12
 2022))
 with ESMTPS id <0ROA003X90IJQH20@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 10 Jan 2023 15:32:43 +0000 (GMT)
Date: Tue, 10 Jan 2023 16:32:16 +0100
To: David Sterba <dsterba@suse.cz>
Message-id: <20230110153216.GA10159@lst.de>
References: <20230108165645.381077-1-hch@lst.de>
 <20230109195309.GU11562@twin.jikos.cz> <20230110081653.GA11947@lst.de>
 <20230110130042.GA11562@suse.cz>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20230110130042.GA11562@suse.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Source-IP: 213.95.11.211
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10586
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 priorityscore=0
 lowpriorityscore=0 phishscore=0 suspectscore=0 clxscore=227 impostorscore=0
 mlxscore=0 mlxlogscore=772 spamscore=0 malwarescore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301100096
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
X-Proofpoint-GUID: Oda8LC8FBM683-h-_5wJbFAaYyJaZHvL
X-Proofpoint-ORIG-GUID: Oda8LC8FBM683-h-_5wJbFAaYyJaZHvL
Reporting-Meta:
 AAGOmAW9sfHww+gNiu5eeIxzyrARmi+HXIjDx1Izo9FDta57TSTE8vnsSGLAC0RH
 dDRoTze3xAaBLAdlBEW9MBU2iDkzuJZfeU/FJVGaG+K+p6oiJIPETq8UinbBAkEa
 hKCbOOfcDUKKbTNrEvsNmQKHeFxGHmlLghnZyA9zacpW/IcU8SSjcAn+CenhwPSr
 wxoGjiwWGbcaRMNLGtIJHrF/s0fdquziKtF8pUdzogTOVbL3KMxEstajVOc4F4hU
 OHri4bL1tOl3gbo5yU6Cdby/7tOn6D4bV+5M6Ficj8VODKaPHGC4obhekgs3J47V
 KuOnrs5QCKaQoqhe4MpqBKycct32xYXXaMSGyYmbIvFMqThCUBYjByMJBUNlSfJF
 ONADzNOoCm/QH1+FeDyiwHlx5yDyMaVHy25V2iSSPmGQbK3L4HPPNvXDLQxuJZOg
 Otue9FYWMKEpVIePmVSWYfbZj7ZKI3b7CHDjwXQFUrCHlY38xez/T+ZIniFfipOW
 tYT9kdxDHmV8XK4zzURuUWw8Iwc43RGaTitNq6KSMQ==

On Tue, Jan 10, 2023 at 02:00:42PM +0100, David Sterba wrote:
> On Tue, Jan 10, 2023 at 09:16:53AM +0100, Christoph Hellwig wrote:
> > On Mon, Jan 09, 2023 at 08:53:09PM +0100, David Sterba wrote:
> > > The btrfs patches were sent separately some time ago, now merged to
> > > misc-next with updated changelogs and with the suggested switch to folio
> > > API in the 2nd patch.
> > 
> > Yes, 7 weeks ago to be exact.  I wish we could just feed everything
> > together now that we've missed the previous merge window, as that
> > makes patch juggling for Andrew and Matthew a lot simpler.
> 
> The patches are not fixes so they should wait for the next merge window.

Agreed.  But it would be a lot simpler if we could queue them up in
-mm with the other patches now that we've missed the previous merge
window.

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
