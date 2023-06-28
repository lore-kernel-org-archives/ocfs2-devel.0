Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36652EB64D7
	for <ocfs2-devel@archiver.kernel.org>; Fri, 30 Jun 2023 17:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Vz+bbguLmbJHHhYEUcXPhUCc4riZm7A4siaHaybm/Uc=;
 b=x+JOvxc4CossgPSIRn7g0AHRruaIjmFFOUWBR6HEvYt9srTJeqh/juMQ1H0yVsLpT8qPFTdC3jHb
   APcKL9YD5EmvEC2rWHSkKnoV/A5VupOqlNfzSeJW7MwPUM0FdYZ7OkYxALjVNnJU6rtMCzPVyWqK
   vvijMVfY2svRHimrKg1OdbopUKuMHPYKZHIZFGoxSRVIQcMOQtU2ATvC/3aE0eO7NeMXijCwHS9C
   HggIqc4afkp106xI0ecKXz/+rtpmu7EtKcTgxdItagHQdaGEoTZK+C1KWAUZFkJYsLcUXWOBEWWz
   kT5jP/+a01nt5SxK+wQBJJIQ6+ycpdfHwvMa1g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Vz+bbguLmbJHHhYEUcXPhUCc4riZm7A4siaHaybm/Uc=;
 b=k7Dx7qF+GM4iTohGmX6x7Ax93zGFBl+rZULeiRyGKNXNrlP5sO+8vfHwvY8tOqo7cDV3yZX8hu5u
   mebtFfBQExqv8lJjM4XppiRQ3sk8eyEzpGrGtY4E9TpDJNOz9gfi1TEe175E1qFkMp0AnyP5ABr6
   MnsHQrDRC9ozh3xSruC48tZ3MTF2uJ2VJASV4iieNE1MOmth6EPO54NFFul0gEoIH0wrxaTX3+XA
   Qkqb+0mpOOo/JKpGDxyFCopBn21B6zWftFk9a73v2Lwmm6g2kUpnjL8xf5QAaGBCy0VlHmKKkavn
   Gu1kMS6XGEZtJrhGwTicIq9LQ0lm4OFM3YtsBg==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230523 64bit (built May 23
 2023))
 with ESMTPS id <0RX2007UEV26VV20@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 30 Jun 2023 17:54:06 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
 t=1687916146;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type;
 bh=t5C1FqxbhDihTAvRsiJRCAZuV1hpcNCdAw+KOFRVobY=;
 b=VAeonAyzNDTcfWBYSd2QZ/vYiSxXduYwyskNrtOLFmJerUvqJCtHEFm5MIBCcjwnn66+Pf
 ZCpktB3/ysg0PygfQVCyLQrvDMaeIpSjNWDbXuLzAsn0JmwzmcJrQUBclC3Tj3G4t9Ltmv
 9MRAbh5p78nji3479CoaCv1kTy7E2KI=
Date: Wed, 28 Jun 2023 03:35:45 +0200
To: ocfs2-devel@lists.linux.dev
Message-id: <ZJuOcTIxSK8VeTk6@technoir>
MIME-version: 1.0
Content-disposition: inline
X-Source-IP: 195.135.220.28
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10754
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
 priorityscore=154 suspectscore=0 mlxlogscore=999 bulkscore=0 adultscore=0
 lowpriorityscore=0 malwarescore=0 clxscore=256 impostorscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306280013 domainage_hfrom=9773
Cc: ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] announcement: ocfs2-devel mailing list migration to
	kernel.org
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
From: Anthony Iliopoulos via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Anthony Iliopoulos <ailiop@suse.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: smtp-out1.suse.de
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: urum3YehnlMR7s8cmXd6HjU73KXmg0Kk
X-Proofpoint-ORIG-GUID: urum3YehnlMR7s8cmXd6HjU73KXmg0Kk
X-Mailman-Approved-At: Fri, 30 Jun 2023 17:54:03 +0000
Reporting-Meta:
 AAEn1VKZNJY1vdf+47NjdHUFNfVRoPhG0hC2/4BPTvKxVHdLejnux/CpQOaPHbR2
 GIAGKLWFiTdwZT7dBTnT4IKU8efHqgYYnx4o5B2TI0Wql0Z8DJlaorASuPbxLcJk
 ZrX+jxW7uwrYQ/L6XgcvZROmMEeNJY1+UEO/2LsoCbyOnB0hUou//82O5GZTCcUJ
 UlzYuByuTUTl1PyAU85LCtgZdjeQBCSYLF43XAgUGB1Qmk5URWGYPr1EtVFX/iDq
 VZ3v35+aZta6sE9TSb9du3Zz1zB6yrpypaxxzEp5rb/WEF05nRCLFG5Riax4nqGY
 lNVw+olyCCxB3Jnad/mJViaDwaTmBG8u7DbBjicC71/PVveRPaf+sPCq/YDk0lbl
 uDwBa0nzHXXv2MsAmpWHC0Nbqg85rleIa67F+4I7KI54E3eJVMpZicd9qg2bdk9x
 u5naVrCDayFjkWyVVewIpOiGPtX/mTkjvFQL0M4ftMQ4nQ412QeIyuxrajuyGQdz
 O10rNPpPEnxhqd4gaBvu1hDok6AJw9Vt5E4zGM19WIw=

Greetings all,

The ocfs2-devel mailing list has now been migrated to the kernel.org
infrastructure [1].

Members of the old list [2] are already automatically subscribed to the
new mailing list, so you do not need to do anything further (other than
potentially adjusting any mail filters to match the new address).

All the previous archives will continue being accessible at lore [3],
which will soon start monitoring and archiving only from the new list.

Henceforth, please post all patches and related discussion at the new
address [4], as the old list will be decommissioned.

I'll send out patches to update the kernel docs and related pointers to
reflect the change accordingly.

Regards,
Anthony

[1] https://subspace.kernel.org/lists.linux.dev.html
[2] https://oss.oracle.com/mailman/listinfo/ocfs2-devel
[3] https://lore.kernel.org/ocfs2-devel/
[4] ocfs2-devel@lists.linux.dev

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
