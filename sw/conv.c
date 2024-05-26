#include <stdio.h>
#include <stdint.h>

uint8_t CONV_vGetDiagSize(const uint8_t u8XSize, const uint8_t u8YSize)
{
	uint8_t u8DiagonalSize = 0;

	u8DiagonalSize = (u8XSize + u8YSize) - 1;

	return u8DiagonalSize;
}

uint8_t CONV_u8CalculateDiagonals(const uint8_t sizeX,
																	const uint8_t sizeY,
																	int16_t s16DataTempZ[32][32],
																	int16_t s16DataOutZ[64])
{
	int8_t s8Rows = 0; /* X Index : Rows */
	int8_t s8Cols = 0; /* Y Index : Columns */

	uint8_t u8DiagSize = 0; /* Number of diagonals */
	int16_t s16Temp = 0;

	/* Get diagonal Size */
	u8DiagSize = CONV_vGetDiagSize (sizeX, sizeY);

	/* Iterate through n diagonals */
	for (int8_t s8StartColumn = 0; s8StartColumn < u8DiagSize; s8StartColumn++)
	{
		s16Temp = 0; /* Diagonal Sum  */
		s8Rows = 0; /* From row Zero */
		s8Cols = s8StartColumn; /* From column StartColumn */

		/* Iterate through n + 1 operations */
		while (s8Rows < sizeX && s8Cols >= 0)
		{
			s16Temp += s16DataTempZ[s8Rows][s8Cols];
			s8Rows++;
			s8Cols--;
		}

		s16DataOutZ[s8StartColumn] = s16Temp;
	}

	return u8DiagSize;
}

uint8_t CONV_u8CalculateConvolution(const uint8_t sizeX,
																		const uint8_t sizeY,
																		int8_t *dataX,
																		int8_t *dataY,
																		int16_t *dataZ)
{
	int8_t xAddr = 0; /* X Index : Rows */
	int8_t yAddr = 0; /* Y Index : Columns */

	uint8_t nDiag = 0; /* Number of diagonals */
	int16_t s16Temp = 0;
	int16_t s16Product = 0;

	/* Get Samples Size */
	nDiag = (sizeX + sizeY) - 1;

	/* Iterate through n diagonals */
	for (int8_t cDiag = 0; cDiag < nDiag; cDiag++)
	{
		s16Temp = 0; /* Diagonal Sum  */

		if (cDiag < sizeY) {
			xAddr = 0;
			yAddr = cDiag;
		} else {
			xAddr = cDiag - sizeY + 1;
			yAddr = sizeY - 1;
		}

		/* Iterate through n + 1 operations */
		while (xAddr < sizeX && yAddr >= 0)
		{
			s16Product = (dataX[xAddr] * dataY[yAddr]);
			s16Temp += s16Product;
			xAddr++;
			yAddr--;
		}

		dataZ[cDiag] = s16Temp;
	}

	return nDiag;
}

int main ()
{
	uint8_t u8FinalSize = 0;
	int8_t s8DataX[] = { 0, 5, 5, 5, 0 };
	int8_t s8DataY[] = { 0, 5, 5, 5, 0};
	int16_t s16Ztemp[32][32] = {0};
	int16_t s16Zout[64] = {0};
	int16_t s16Temp = {0};
	uint8_t u8SizeX = 5;
	uint8_t u8SizeY = 5;

	for (int i = 0; i < u8SizeX; i++)
	{
		for (int j = 0; j < u8SizeY; j++)
		{
		  s16Temp	= (int16_t) (s8DataX[i] * s8DataY[j]);
		  s16Ztemp[i][j] = s16Temp;
		}
	}

	for (int i = 0; i < u8SizeX; i++)
	{
		for (int j = 0; j < u8SizeY; j++)
		{
			printf ("%4d ", s16Ztemp[i][j]);
			if (j == (u8SizeY-1) )
			{
				printf("\n");
			}
		}
	}

	//u8FinalSize = CONV_u8CalculateDiagonals (u8SizeX, u8SizeY, s16Ztemp, s16Zout);
	u8FinalSize = CONV_u8CalculateConvolution (u8SizeX, u8SizeY, s8DataX, s8DataY, s16Zout);

	printf("\n");
	for (int k = 0; k < u8FinalSize; k++)
	{
		printf ("%4d ", s16Zout[k]);
	}

	return 0;
}