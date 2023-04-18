Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc246.phx1.oracleemaildelivery.com (aib29ajc246.phx1.oracleemaildelivery.com [192.29.103.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA0DAC77B72
	for <ocfs2-devel@archiver.kernel.org>; Thu, 20 Apr 2023 16:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=d/MEqRU7v6ZFHVYeDEEfTeMh7kp0Er2Hubz38+PsPEc=;
 b=g+uqqHQxz48UW5gsh+5sohX57K9Brs1kwksrBL/4nt10kZAdfgk8NoTczxGBLcbQgPrWiHVUjo51
   kFKsf2jy6uV2olkIpNkq6AV1Dmd5T+kRaG/GxGMHZ9CexE85QOrgNZgv0o85Xv3QGXpoyNgU/dnP
   WS8LkGthmnPmgNgNXfEhfxBfgX9c7k/Lj3Ne1joq6GBcwH6anBqosrkcdUyWWEahb1mUHCrnqWoa
   FyGr7M8taKVQQMuGpfY/HT+6646qtIBOj2kGKN0M4Qo03cy95pYcD6KOq+eGeFk9s2Jsq1zW78uJ
   NeLAf6ccucP98cDZ1UaO4RpyLmNt/RXKu1afrQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=d/MEqRU7v6ZFHVYeDEEfTeMh7kp0Er2Hubz38+PsPEc=;
 b=VSm6AzSPjKEvP3cut9NPiEKCWmAlro0qVzqTXn86UuvIeoq2ab6EMEMmXGfQ4ieS6UMLvbah75sx
   j0t0BWhi5wpEOfarkyEAt1hI7YUMhzWYHnsKNNyt7l52h8Mp53GrZiRlTYL33OCLjzn0hfRQqc+E
   nWdM3X8iv9GUF7bgYL4kVCUkwaStIfT/QVa1Bbktj9PgTw8k+gH9HepcKimzJlNLlLYA4y0nzxRT
   oaNyMzqMphY1su7fYVANwCGOXVPkiMLo7UCKsuNfo0h26UnGWrQGZttYS9k89wbkZ++L7i3FEcb1
   0ePDwq2KJvV7mSmxhv44gCFcJ4jPXEj5YpzaEQ==
Received: by omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230407 64bit (built Apr  7
 2023))
 with ESMTPS id <0RTF00OLT9HTJWB0@omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 20 Apr 2023 16:22:41 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
 t=1682007713; bh=P55Ye25BDJCTcXLNroTjSNzxxGD0p5Uoc9h9dHTaUKI=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To;
 b=gf0I9gLVKvEwyJg8K5OK1SL6nKdfR+wRkceYLvWkMK9kqAeUP9PTV26fXq6nw0x+y
 DqKX7NFuYE+d5u0UPimEfsoy+kBDxDBjzJgZu0ofv8YgTdyuW+N4e6iIAl9vCd9Sry
 pcHHK5EPD7qba03M1Si/N5hmet6jtSwXfvjwBhD24jYT0vZKQhH1iw77Jm3vJoBLkI
 SmPxfhRFTIQ/AR/q0yl8uDeuj3EL2MtZoCsNw4nRR6acViwDGk3atIe3k/84Xb26QE
 SNXHjGnN2Z1DYcF5SLdfAGmq4m+PXJiUut7pfiKdqQuEu4DaKM31foyoD7FvFf5nFK
 5NdH/n0aOY0IA==
Date: Tue, 18 Apr 2023 14:02:02 -0400
To: Christian Brauner <brauner@kernel.org>
Message-id: <20230418180202.GA602488@mit.edu>
References: <20230417205631.1956027-1-arnd@kernel.org>
 <20230418-fortgehen-inkubationszeit-5d3db3f0c2b1@brauner>
 <7555eaf9-b195-5189-3928-c7292e4a0ba5@linux.alibaba.com>
 <20230418-vielmehr-nominieren-7f2adb0f6703@brauner>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20230418-vielmehr-nominieren-7f2adb0f6703@brauner>
X-Source-IP: 18.9.28.11
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10686
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 adultscore=0 spamscore=0 phishscore=0
 clxscore=162 mlxlogscore=999 mlxscore=0 priorityscore=138 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304200135 domainage_hfrom=13846
Cc: Arnd Bergmann <arnd@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 ocfs2-devel <ocfs2-devel@oss.oracle.com>
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: reduce ioctl stack usage
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
X-Proofpoint-ORIG-GUID: 9bkSnpuTHGh_AK3LbYEXpyjbogoghgGq
X-Proofpoint-GUID: 9bkSnpuTHGh_AK3LbYEXpyjbogoghgGq
Reporting-Meta:
 AAGe+12OIE8WFCJsab/zwkM9c7mEOOV4FNaRt/+jRKnDAuxMb5MIKN2QqMiAEL3j
 3bcZ7IP3E0flaq6M1Tx4d+Y/90hNFuIBW9u6C78EMGFqlv7RYkF7cXu7BWsuDswp
 Y21Hncqs6+zZy+H2h+mzQHMC3UIX/8bDUjfjyE3iZtUyHQzFWaTIXDLewJvqKoxI
 W6bvIaetxTK5St1D+QAS6rNGoUU582eUN4VXCrl1YxQh6XVwaU506FTrXBx7alR3
 Ip9BKxOVqcDla4S7QK+jvAdfjrwbqAhD4cr8fmQlSO46wbHsUy6For2WHb7dOhJO
 o51KDB1Jtk8s/+6qZzVhKFTYcAeClLntlXCl1ZHJZCrAXorUUpq8d6Eat1x4qCfj
 EwIy69LY/91CxZVG6sZrYTIp2PZdY9f0H2qKBTmbpK2NF9ajeZ5xoHkbGzgIiX2S
 ZQm4EHOqlq8HZLK7QPayu/TYRYzQCG1QN5sYbqE1DYh3wFdvYc+eHUZ4+3kInLeF
 l2hu3rHE3nDn6Lia5ebtN2znXMji+ZNQl6VtnbAcS3w=

On Tue, Apr 18, 2023 at 02:56:38PM +0200, Christian Brauner wrote:
> On Tue, Apr 18, 2023 at 05:37:06PM +0800, Joseph Qi wrote:
> > Andrew picked ocfs2 patches into -mm tree before.
> 
> Yup and that's fine obviously, but this belongs to fs/ and we're aiming
> to take fs/ stuff through the dedicated fs trees going forward.

The challenge here is that there isn't an active ocfs2 tree at the
moment (git/jlbec/ocfs2.git was last updated 11 years ago), and it's
not clear ocfs2 has an active maintainer, although as discussed at a
recent ext4 telechat, there still are some enterprise users of it
hanging on.

We're starting considering changes to fs/jbd2 so we can get off of
using the struct bh for jbd2 (still very early days; it's more in the
early concept brain-storming stage.)  And since ocfs2 also uses
fs/jbd2, the fact that ocfs2 isn't under active maintenance is going
to be more of a challenge moving forward.

Something we should discuss in the hallway track of LSF/MM, perhaps...

							- Ted

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
