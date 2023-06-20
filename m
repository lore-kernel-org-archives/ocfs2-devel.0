Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 402CBEB64DA
	for <ocfs2-devel@archiver.kernel.org>; Tue, 20 Jun 2023 03:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=wn+gKb97RCmzRnA3UzFJLDNJmFbZxzCXasvw8ORjoPk=;
 b=CCIIC2vdCnAWL5w9GHoGUuL2rRoMUCd/rBxNxgEplBJV7+tkbSYLy19GnNmbjdk2kOdW1smnTDQP
   TZ5Pwu7ln+HKmwAKIZ0IffnwFTkEFQA8XPavgK9YeCepo9v9P/eqrZnbFY9bCqXuZQlXI6mSwT8a
   dtH35ZrJQrZHrXLp7Va7/IPzQHb2hIuztJ2wHQXsuqyD973K/7dkfIPJwm2bfq49x0Kg0d0oSmsO
   E2G/NNb11lS9dtddlasBj0kNMowbT4UX4scmK8iOPe4H79fLj3w/kx20kchSkeOf6wYDJzcvd/sv
   /v0kgw05J+SdtFTvBwwlt+8eCtlFf3ErTWARwg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=wn+gKb97RCmzRnA3UzFJLDNJmFbZxzCXasvw8ORjoPk=;
 b=iami0OtsuDSnXEl1akxmZN+Nbd8w2/o2Y+KBxpElLbbmuARPBQPxMkNYHlAYk6sebjzWzyPt8/rz
   ZgaN9lYMweB4qwCPtPDYnLdYyX/FPGMPJ8Ka04BHy1GTTDxJAvt9QO9KMDJJF3ch4so4zPpmtOKe
   K9R6PHk+np2dxwB8FqW/FixrJ5OHseJFeOH9MuOs41eTFgLbbJmiapHHqAxhsfEeoKn4rg8HY5eC
   vBmR+goIeBo5aQ3ietV838Fa9oMRfvMN0nnLojPWJ3UkS7qRfUu4RI5yxxeO+Q0HFGWYxjFNUfp9
   Wr67LupS6o4XawDpPM1UMAX59jPt7RZDWil+Xg==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230523 64bit (built May 23
 2023))
 with ESMTPS id <0RWJ008WM732HZ20@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 20 Jun 2023 03:01:50 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
 t=1687230043; bh=3n8GAvW8QrSdojYTtSqja8VtHL/WSJb5DJjbA1RhY/4=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To;
 b=aUyd5I4x+bUQbJVVDNU1LP7CcS8iqNF2nVC4QkPqnPVd93PxKQYTmFUwe120hvjHD
 LB6h2MDwE6KWqQS/tavsoozxBdF8t89kTVyqKzLZ0KJ/kqat81JoV6Y1o6VTQzb/FS
 YJXhYJkq5smhu/5yG/JJ4PeZ0JGmO7k5uDa6cy5qIEg4W8UqrEmsLlJPkKP0dgCagA
 wHaY9uUBazQtotST8InhIsVYklyPBIb8xy7TIBYcp69ooaFdxTYfNZ2lj0z0bv/I1r
 xXTMQf/RSUjW0XIxhx6COquVPobNMxJpZ4pACwe8uQyfu9P2W+Q1CpcRGw0kUCP2FT
 +SSM25sLqEa4A==
Date: Mon, 19 Jun 2023 23:00:37 -0400
To: Bean Huo <beanhuo@iokpp.de>
Message-id: <20230620030037.GF286961@mit.edu>
References: <20230619211827.707054-1-beanhuo@iokpp.de>
 <20230619211827.707054-3-beanhuo@iokpp.de>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20230619211827.707054-3-beanhuo@iokpp.de>
X-Source-IP: 18.9.28.11
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10746
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxlogscore=670
 priorityscore=78 impostorscore=0 mlxscore=0 clxscore=149 spamscore=0
 suspectscore=0 phishscore=0 bulkscore=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306200026 domainage_hfrom=13907
Cc: brauner@kernel.org, jack@suse.cz, linux-kernel@vger.kernel.org,
 beanhuo@micron.com, adilger.kernel@dilger.ca, viro@zeniv.linux.org.uk,
 jack@suse.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v2 2/5] ext4: No need to check return value
 of block_commit_write()
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
From: Theodore Ts'o via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Theodore Ts'o <tytso@mit.edu>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: outgoing-auth-1.mit.edu
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:_s00430413.autospf.email -all
X-Spam: Clean
X-Proofpoint-GUID: B36ehU9f6iIZHJZGUfstncBadeS_zwPn
X-Proofpoint-ORIG-GUID: B36ehU9f6iIZHJZGUfstncBadeS_zwPn
Reporting-Meta:
 AAEO0Sy2sKwV/GIpyIDUn/x952sTidu9ti/OkP5XoqbQqhIqhCSca0+JsUm/m8Mf
 FZ/TInEJyH/1j9yegpdho7A0ESg1p2ZqKBXNFKPGSZWcodPu4AfcTwrrGN+JvyI2
 s51jiPtLlymTqTYQn0Z0QY5DWAvV5vF+9rF4AbFGR/Jni9ofbDxQE6jfGMSBcIny
 91gat4fifEfRr5fnp4dh+vA3QKO5t9oD00SijkfntVzhE+ciP+ESoAUlkdVYr2Sd
 HuST0f4x6B5dYmFuUQwuU5/J/8RfjnnPiCe8CuESjr+JkOBB12w71Zzw18u5XQGG
 W+493wm2NF9EZEO48ZHq8C1nKQ0ricz2+iACOFLRHCsMqVB52CX3WqxCjozTC7SS
 Ez2lG1ZyJONDjHKWFxTNEMow+BvhzH3LXfNhPcX/x+hXV5HvNmwXDv1EjTuznvL7
 YB06DU8EP4PWKu3sooJ5BgC8O500VyOINIX4MmPJVAnuBarVSrbFYmGSmauyXg4y
 J8Yqz3E0c8Byo3npT6ddbMRQFocfE/lpzP5bebPTmR0I

On Mon, Jun 19, 2023 at 11:18:24PM +0200, Bean Huo wrote:
> From: Bean Huo <beanhuo@micron.com>
> 
> Remove unnecessary check on the return value of block_commit_write(),
> because it always returns 0.
> 
> Signed-off-by: Bean Huo <beanhuo@micron.com>
> Reviewed-by: Jan Kara <jack@suse.cz>

Acked-by: Theodore Ts'o <tytso@mit.edu>

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
